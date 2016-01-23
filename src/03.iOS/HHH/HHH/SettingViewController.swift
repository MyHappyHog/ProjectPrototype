//
//  SettingViewController.swift
//  HHHPrototype
//
//  Created by Yoonseung Choi on 2015. 10. 14..
//  Copyright © 2015년 Yoonseung Choi. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    //var isExpanding : Bool = false
    var clickForExpanding = [false, false, false, false]
    var cellHeightArray : [CGFloat] = [0.0, 400.0, 200.0, 220.0]
    var now_expanding : Int = -1
    var num_expanded : Int = 0
    
    let imgPicker = UIImagePickerController()
    var image: UIImage? = nil
    
    @IBOutlet weak var textfieldMinTemperature: UITextField!
    @IBOutlet weak var textfieldMaxTemperature: UITextField!
    @IBOutlet weak var textfieldMinHunidity: UITextField!
    @IBOutlet weak var textfieldMaxHumidity: UITextField!
    
    @IBOutlet weak var textfieldName: UITextField!
    @IBOutlet weak var textfieldMemo: UITextField!
    @IBOutlet weak var textfieldServer: UITextField!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let coredata = coreData(entity: "User")
        if(coredata.getCount() != 0){//
            let index = dataStore.index!
            self.textfieldName.text = coredata.getDatasIndex(index, key: "title") as? String
            self.textfieldMemo.text = coredata.getDatasIndex(index, key: "memo") as? String
            self.textfieldServer.text = coredata.getDatasIndex(index, key: "server_addr") as? String
            
            print(coredata.getDatasIndex(index, key: "minTemp") as! Int)
            self.textfieldMinTemperature.text = String(coredata.getDatasIndex(index, key: "minTemp") as! Int)
            self.textfieldMaxTemperature.text = String(coredata.getDatasIndex(index, key: "maxTemp") as! Int)
            self.textfieldMinHunidity.text = String(coredata.getDatasIndex(index, key: "minhum") as! Int)
            self.textfieldMaxHumidity.text = String(coredata.getDatasIndex(index, key: "maxhum") as! Int)
            self.profileImage.image = UIImage(data: coredata.getDatasIndex(index, key: "image") as! NSData)
        }
        
        imgPicker.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        tap.delegate = self
        profileImage.userInteractionEnabled = true
        profileImage.addGestureRecognizer(tap)
        
        //chagne value from core data
        segementHumid.selectedSegmentIndex = 1
        segementLight.selectedSegmentIndex = 2

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
    
    
    @IBAction func clickSaveBtn(sender: AnyObject) {
        let coredata = coreData(entity: "User")
        let http_reference = HttpReference(coredata.getDatasIndex(0, key: "server_addr") as? String)
        
        if textfieldMaxTemperature == nil{

        }
        
        
        http_reference.postSensorData(Int((textfieldMaxTemperature.text! as String))!,
            minTemprature: Int((textfieldMinTemperature.text! as String))!,
            maxHumidity: Int((textfieldMaxHumidity.text! as String))!,
            minHumidity: Int((textfieldMinHunidity.text! as String))!)
        
        
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    /* shows the photo library when the changing profile image button pressed */
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
