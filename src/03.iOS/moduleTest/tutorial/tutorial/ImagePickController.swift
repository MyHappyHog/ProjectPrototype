//
//  ImagePickController.swift
//  tutorial
//
//  Created by Yoonseung Choi on 2015. 10. 3..
//  Copyright © 2015년 Yoonseung Choi. All rights reserved.
//

import UIKit

class ImagePickController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var currentImage: UIImage!
    
    let imagePicker = UIImagePickerController()


    @IBOutlet weak var ProfileNowDisplaying: UIImageView!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        ProfileNowDisplaying.image = currentImage
        imagePicker.delegate = self

        
    }
    
    
    
    @IBAction func ButtonPhotoLibrary(sender: AnyObject) {
        
        imagePicker.allowsEditing = false
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    

    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        ProfileNowDisplaying.image = image
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func ButtonAction(sender: AnyObject) {
        performSegueWithIdentifier("apply", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        let nextVC: ViewController = segue.destinationViewController as! ViewController
        
        // must set the storyboard segue identifier
        switch segue.identifier!{
            
        case "apply":
            
            nextVC.currentImage = ProfileNowDisplaying.image
            break
            
        case "cancel":
            
            nextVC.currentImage = currentImage
            break
            
        default:
            break
        }
    }


}



// Choosing Images with UIImagePickerController in Swift
// http://www.codingexplorer.com/choosing-images-with-uiimagepickercontroller-in-swift/