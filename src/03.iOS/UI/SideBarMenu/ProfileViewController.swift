//
//  ProfileViewController.swift
//  HappyHog
//
//  Created by nlplab on 2015. 10. 5..
//  Copyright © 2015년 Alexandre. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var memo: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBAction func nameChangeFunc(sender: AnyObject) {
    }
    @IBAction func nameChange(sender: AnyObject) {
       
    }
    
    @IBAction func changeImageButton(sender: AnyObject) {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(myPickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        profileImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    //change the main name, memo
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController as? ViewController
        destination!.nameLabelText = name.text
        destination!.memoLabelText = memo.text
        destination!.images = profileImage.image
    }
    
    
       // name.placeholder = "aa"
     /*   //initialize
        let actionSheetController: UIAlertController = UIAlertController(title: "change the name", message: "enter the new name", preferredStyle: .Alert)
            
        let applyButton: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {action -> Void in})
            
        let cancelButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { action ->Void in})
        
        //add the name
        actionSheetController.addAction(cancelButton)
        actionSheetController.addAction(applyButton)
        
        actionSheetController.addTextFieldWithConfigurationHandler({textField -> Void in
            
            textField.placeholder = self.name.text })*/


}