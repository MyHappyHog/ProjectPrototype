//
//  SettingViewController.swift
//  HHHPrototype
//
//  Created by Yoonseung Choi on 2015. 10. 14..
//  Copyright © 2015년 Yoonseung Choi. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    var profileImg: UIImage!
    var profileName: String!
    var profileMemo: String!
    
    @IBOutlet weak var CurrentProfileImage: UIImageView!
    @IBOutlet weak var NameTextField: UITextField!
    @IBOutlet weak var MemoTextField: UITextField!
    @IBOutlet weak var DeviceTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        CurrentProfileImage.image = profileImg
        NameTextField.text = profileName
        MemoTextField.text = profileMemo
    }
    
    
    /* shows the photo library when the changing profile image button pressed */
    @IBAction func ChangeProfileImage(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    /* change the profile image when user choose the new profile image in the photo library */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        CurrentProfileImage.image = image // change profile image to choosen image
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /* did not change the profile image when user choose the cancel in the photo library */
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    @IBAction func DoneOnClicked(sender: AnyObject) {
        performSegueWithIdentifier("Intro", sender: nil)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "Intro" :
            let nextViewController:IntroViewController = segue.destinationViewController as! IntroViewController
            nextViewController.profileImg = CurrentProfileImage.image!
            nextViewController.profileName = NameTextField.text!
            nextViewController.profileMemo = MemoTextField.text!
            
            break
        default:
            break
            
        }
    }
    
}
