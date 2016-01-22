//
//  SettingViewController.swift
//  HHHPrototype
//
//  Created by Yoonseung Choi on 2015. 10. 14..
//  Copyright © 2015년 Yoonseung Choi. All rights reserved.
//

import UIKit

class addPetViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    //var isExpanding : Bool = false
    var clickForExpanding = [false, false, false, false]
    var cellHeightArray : [CGFloat] = [0.0, 400.0, 200.0, 300.0]
    var now_expanding : Int = -1
    var num_expanded : Int = 0
    
    let imgPicker = UIImagePickerController()
    var image :UIImage = UIImage(named: "sampleant")!
    
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var memoTxt: UITextField!
    @IBOutlet weak var serverTxt: UITextField!
    //
    @IBOutlet weak var textfieldMinTemp: UITextField!
    @IBOutlet weak var textfieldMaxTemp: UITextField!
    @IBOutlet weak var textfieldMinHumi: UITextField!
    @IBOutlet weak var textfieldMaxHumi: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 6){
            clickForExpanding[indexPath.row / 2] = !clickForExpanding[indexPath.row / 2]
            tableView.reloadData()
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let index = indexPath.row
        
        if index % 2 == 0 || index > 5{
            return 44.0
        }
        
        return cellHeightArray[((clickForExpanding[index / 2]) ? index / 2 + 1 : 0)]
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    //////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgPicker.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        tap.delegate = self
        profileImage.userInteractionEnabled = true
        profileImage.addGestureRecognizer(tap)
    }
        
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "saveSegue"){
            //coredata save
            let credata = coreData(entity: "User")
            let dP = data_user(image: image, name: nameTxt.text!, memo: memoTxt.text!, server: serverTxt.text!,
                minTemp: Int(textfieldMinTemp.text! as String)!,
                maxTemp: Int(textfieldMaxTemp.text! as String)!,
                minHumid: Int(textfieldMinHumi.text! as String)!,
                maxHumid: Int(textfieldMaxHumi.text! as String)!) as data_user
            credata.insertData(dP)
            let http_reference = HttpReference(serverTxt.text! as String)
            http_reference.postSensorData(Int(textfieldMaxTemp.text! as String)!
                , minTemprature: Int(textfieldMinTemp.text! as String)!,
                maxHumidity: Int(textfieldMaxHumi.text! as String)!,
                minHumidity: Int(textfieldMinHumi.text! as String)!)
        }
    }
    
    
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        imgPicker.allowsEditing = false
        imgPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(imgPicker, animated: true, completion: nil)
    }

    /* change the profile image when user choose the new profile image in the photo library */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let imageUrl          = info[UIImagePickerControllerReferenceURL] as! NSURL
        let imageName : String    = imageUrl.lastPathComponent!
        dataStore.extenstion = imageName
        print(imageName)
        
        let pathExtention = (imageName as NSString).pathExtension
        print(pathExtention)
        
        let newImage: UIImage
        
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        
        self.image = newImage
        self.profileImage.image = self.image
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    /* did not change the profile image when user choose the cancel in the photo library */
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
