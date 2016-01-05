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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgPicker.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        tap.delegate = self
        currentProfileImg.userInteractionEnabled = true
        currentProfileImg.addGestureRecognizer(tap)
        
        let user_coredata = coreData(entity: "User")
        
        self.currentProfileImg.image = UIImage(named: (user_coredata.getDatasIndex(0, key: "image") as? String)!)
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let imageURL = info[UIImagePickerControllerReferenceURL] as! NSURL
        
        let imageUrl          = info[UIImagePickerControllerReferenceURL] as! NSURL
        let imageName         = imageUrl.lastPathComponent
        print(imageName)
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as String!
        let photoURL          = NSURL(fileURLWithPath: documentDirectory)
        let localPath         = photoURL.URLByAppendingPathComponent(imageName!)
        print(localPath)
        
        self.currentProfileImg.image = UIImage(named: localPath.absoluteString)
        
        dismissViewControllerAnimated(true, completion: nil)

    }
    /* change the profile image when user choose the new profile image in the photo library */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [NSObject : AnyObject]?) {
        /*currentProfileImg.image = image // change profile image to choosen image
        
                print(2)
        dismissViewControllerAnimated(true, completion: nil)*/
        
        let imageUrl          = editingInfo![UIImagePickerControllerReferenceURL] as! NSURL
        let imageName         = imageUrl.lastPathComponent
        print(imageName)
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as String!
        let photoURL          = NSURL(fileURLWithPath: documentDirectory)
        let localPath         = photoURL.URLByAppendingPathComponent(imageName!)
        print(localPath)
        let image             = editingInfo![UIImagePickerControllerOriginalImage]as! UIImage
        let data              = UIImagePNGRepresentation(image)
        
    
        
        data!.writeToFile(localPath.absoluteString, atomically: true)
        
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    /* did not change the profile image when user choose the cancel in the photo library */
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
