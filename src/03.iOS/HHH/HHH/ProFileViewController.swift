//
//  ProFileViewController.swift
//  HHH
//
//  Created by Cho YoungHun on 2015. 12. 29..
//  Copyright © 2015년 hhh. All rights reserved.
//

import UIKit
import CoreData

class ProFileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate{
    
    //@IBOutlet weak var textFieldDevice: UITextField!
    @IBOutlet weak var textFieldMemo: UITextField!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var currentProfileImg: UIImageView!
    @IBOutlet weak var settingBtn: UIButton!
    
    
    let imgPicker = UIImagePickerController()
    var profileImge: UIImage!
    
    var text_server1: String?
    var text_server2: String?
    
    var image: UIImage? = nil
    var prev_vc :String? = nil
    
    var user :data_user? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProFileViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        navigationController!.navigationBar.barTintColor = UIColor(red: 69/255, green: 62/255, blue: 52/255, alpha: 1)
        
        imgPicker.delegate = self
        
        settingBtn.backgroundColor = UIColor.clearColor()
        //settingBtn.layer.cornerRadius = 5
        settingBtn.layer.borderWidth = 1
        settingBtn.layer.borderColor = UIColor.blackColor().CGColor
        
        let _tap = UITapGestureRecognizer(target: self, action: #selector(ProFileViewController.handleTap(_:)))
        _tap.delegate = self
        
        currentProfileImg.userInteractionEnabled = true
        currentProfileImg.addGestureRecognizer(_tap)
        
        prev_vc = dataStore.prev_vc
        user = dataStore.temp_user
        
        if prev_vc == "main" || prev_vc == "setting"{
            let user_coredata = coreData(entity: "User")
            let index = dataStore.profile_index
        
            //self.currentProfileImg.image = UIImage(named: (user_coredata.getDatasIndex(0, key: "image") as? String)!)
            self.currentProfileImg.image = UIImage(data: user_coredata.getDatasIndex(index!, key: "image") as! NSData)
            //self.textFieldDevice.text = user_coredata.getDatasIndex(index!, key: "numRotate") as? String
            self.textFieldMemo.text = user_coredata.getDatasIndex(index!, key: "memo") as? String
            self.textFieldName.text = user_coredata.getDatasIndex(index!, key: "title") as? String
            self.text_server1 = user_coredata.getDatasIndex(index!, key: "server_addr1") as? String
            self.text_server2 = user_coredata.getDatasIndex(index!, key: "server_addr2") as? String
        }else{ // add
            //settingBtn.hidden = true
            if user != nil && user?.image != nil{
                currentProfileImg.image = user?.image
            }
        }
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func clickSave(sender: AnyObject) {
        let title: String = textFieldName.text!
        let memo: String = textFieldMemo.text!
        //let server_addr: String = textFieldDevice.text!
        let image: UIImage = currentProfileImg.image!
        
        /*
            여기 저장하는거 건들여야할듯 저 서버 부분
        */
        let dp = data_user(image: image, name: title, memo: memo, server: text_server1!, server1:  text_server2!,
            minTemp: 0, maxTemp: 0, minHumid: 0, maxHumid: 0, temperature_index: 0, humidity_index: 0, numRotate: 0) as data_user
        
        if prev_vc == "main"{
            let coredata = coreData(entity: "User")
            coredata.setProfileViewData(dp, index: dataStore.profile_index!)
        }else{
            if user == nil{
                user = data_user(image: image, name: title, memo: memo, server: text_server1!, server1: text_server2!, minTemp: 0, maxTemp: 0, minHumid: 0, maxHumid: 0, temperature_index: 0, humidity_index: 0, numRotate: 0)
            }else{
                user?.image = image
                user?.name = title
                user?.memo = memo
                user?.server_addr1 = text_server1
                user?.server_addr2 = text_server2
            }
            
            dataStore.temp_user = user
        }
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func clickCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /* shows the photo library when the changing profile image button pressed */
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        imgPicker.allowsEditing = false
        imgPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(imgPicker, animated: true, completion: nil)
    }
    
    var server1_temp: String?, server2_temp:String?
    @IBAction func clickSetting(sender: AnyObject) {
        
        let alert = UIAlertController(title: "하드웨어 설정", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler { (a) -> Void in
            a.text = self.text_server1
            self.server1_temp = a.text
            //print(a.text)
        }
        alert.addTextFieldWithConfigurationHandler { (b) -> Void in
            b.text = self.text_server2
            self.server2_temp = b.text
        }
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            
            let a = alert.textFields![0] as UITextField
            let b = alert.textFields![1] as UITextField
            
            self.text_server1 = a.text! as String
            self.text_server2 = b.text! as String
            
            //print(a.text)
            //print(self.text_server2)
        }))
            
        alert.addAction(UIAlertAction(title: "Cancel", style: .Destructive, handler: { (action: UIAlertAction!) in
            
        }))
        
        
        presentViewController(alert, animated: true, completion: nil)

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
        
        //self.image = newImage
        self.currentProfileImg.image =  newImage//self.image
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    /* did not change the profile image when user choose the cancel in the photo library */
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
