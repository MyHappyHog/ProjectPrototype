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

    @IBOutlet weak var textFieldDevice: UITextField!
    @IBOutlet weak var textFieldMemo: UITextField!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var currentProfileImg: UIImageView!
    
    let imgPicker = UIImagePickerController()
    var profileImge: UIImage!
    
    var image: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user_coredata = coreData(entity: "User")
        
        //self.currentProfileImg.image = UIImage(named: (user_coredata.getDatasIndex(0, key: "image") as? String)!)
        self.textFieldDevice.text = user_coredata.getDatasIndex(0, key: "server_addr") as? String
        self.textFieldMemo.text = user_coredata.getDatasIndex(0, key: "memo") as? String
        self.textFieldName.text = user_coredata.getDatasIndex(0, key: "title") as? String
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
        self.currentProfileImg.image = self.image
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    /* did not change the profile image when user choose the cancel in the photo library */
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
