//
//  ProFileViewController.swift
//  HHH
//
//  Created by Cho YoungHun on 2015. 12. 29..
//  Copyright © 2015년 hhh. All rights reserved.
//

import UIKit

class ProFileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var textFieldDevice: UITextField!
    @IBOutlet weak var textFieldMemo: UITextField!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var currentProfileImg: UIImageView!
    
    let imgPicker = UIImagePickerController()
    var profileImge: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgPicker.delegate = self
    }
    
    
    
    /* shows the photo library when the changing profile image button pressed */
    @IBAction func ChangeProfileImage(sender: AnyObject) {
        imgPicker.allowsEditing = false
        imgPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(imgPicker, animated: true, completion: nil)
    }
    
    /* change the profile image when user choose the new profile image in the photo library */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        currentProfileImg.image = image // change profile image to choosen image
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /* did not change the profile image when user choose the cancel in the photo library */
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
