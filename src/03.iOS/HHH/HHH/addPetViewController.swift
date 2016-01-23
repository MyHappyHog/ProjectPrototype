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
    var cellHeightArray : [CGFloat] = [0.0, 400.0, 200.0, 220.0]
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
    
    
    @IBOutlet weak var segmentTemp: UISegmentedControl!
    @IBOutlet weak var segementLight: UISegmentedControl!
    @IBOutlet weak var segementHumid: UISegmentedControl!

    
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
        
        segementHumid.selectedSegmentIndex = 1
        segementLight.selectedSegmentIndex = 2
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "saveSegue"){
            //coredata save
            
            /////센서 콘피그도 넘기기
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
    
    
    @IBAction func changeSegue(sender: UISegmentedControl) {
        let indexTemp = segmentTemp.selectedSegmentIndex + 1
        let indexHumid = segementHumid.selectedSegmentIndex + 1
        let indexLight = segementLight.selectedSegmentIndex + 1
        if(segementHumid.selectedSegmentIndex == indexTemp - 1){
            segementHumid.selectedSegmentIndex = 6 / indexTemp / indexLight - 1
        }else if(segementLight.selectedSegmentIndex == indexTemp - 1){
            segementLight.selectedSegmentIndex = 6 / indexTemp / indexHumid - 1
        }
    }
    
    @IBAction func changeSegeHumid(sender: UISegmentedControl) {
        let indexTemp = segmentTemp.selectedSegmentIndex + 1
        let indexHumid = segementHumid.selectedSegmentIndex + 1
        let indexLight = segementLight.selectedSegmentIndex + 1
        if(segmentTemp.selectedSegmentIndex == indexHumid - 1){
            segmentTemp.selectedSegmentIndex = 6 / indexHumid / indexLight - 1
        }else if(segementLight.selectedSegmentIndex == indexHumid - 1){
            segementLight.selectedSegmentIndex = 6 / indexHumid / indexTemp - 1
        }
    }
    
    @IBAction func changeSegeLight(sender: UISegmentedControl) {
        let indexTemp = segmentTemp.selectedSegmentIndex + 1
        let indexHumid = segementHumid.selectedSegmentIndex + 1
        let indexLight = segementLight.selectedSegmentIndex + 1
        if(segmentTemp.selectedSegmentIndex == indexLight - 1){
            segmentTemp.selectedSegmentIndex = 6 / indexHumid / indexLight - 1
        }else if(segementHumid.selectedSegmentIndex == indexLight - 1){
            segementHumid.selectedSegmentIndex = 6 / indexLight / indexTemp - 1
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
