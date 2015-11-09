//
//  ViewController.swift
//  tutorial
//
//  Created by Yoonseung Choi on 2015. 10. 3..
//  Copyright © 2015 Yoonseung Choi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    /*************************************************************
    
    1. Change the name
    
    This step is about showing the name and changing the name.
    
    One label and one button must be on Storyboard.
    
    *************************************************************/
    

    /* Name Label will be on top of first storyboard. */
    @IBOutlet weak var LableName: UILabel!
    
    /* If Button next to the name is pushed, Alert View will pop up for change the name. */
    @IBAction func ButtonChangeName(sender: AnyObject) {
        
        
        /* Initialize UIAlertController for Name Changing Modal View */
        let actionSheetController: UIAlertController = UIAlertController(title: "Change name button Pushed", message: "enter your new name", preferredStyle: .Alert)
        
        /* Initialize Buttons for Name Change View */
        let cancelButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { action -> Void in} )
        
        let applyButton: UIAlertAction = UIAlertAction(title: "Change from '" + self.LableName.text! + "'", style: UIAlertActionStyle.Default, handler: {action -> Void in
            self.LableName.text = (actionSheetController.textFields!.first)!.text!
            
        })
        
        /* Add Text Field to Name Changing Modal View */
        actionSheetController.addTextFieldWithConfigurationHandler({textField -> Void in
            
            textField.placeholder = self.LableName.text
            textField.textColor = UIColor.grayColor()
        })
        
        /* Add Action Buttons to Name Changing Modal View */
        actionSheetController.addAction(cancelButton)
        actionSheetController.addAction(applyButton)
        
        /* Name Change View be Pop Up */
        self.presentViewController(actionSheetController, animated: true, completion: nil)
        
    }

    /*************************************************************
    
    2. Change the Photo
    
    This step is about showing the name and changing the name.
    
    One label and one button must be on Storyboard.
    
    *************************************************************/
    
    var currentImage: UIImage! = UIImage(named: "shovel.jpg")
    
    @IBOutlet weak var ImageProfile: UIImageView!
    //var currentImage = UIImage(named: "shovel.jpg")
    
    @IBAction func ButtonChangePhoto(sender: AnyObject) {
        performSegueWithIdentifier("firstSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        // must set the storyboard segue identifier
        switch segue.identifier!{
        
        case "firstSegue":
            
            let nextVC: ImagePickController = segue.destinationViewController as! ImagePickController
            nextVC.currentImage = currentImage
            break
            
        default:
            break
        }
    }

    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        LableName.text = "Hi👋🏻" // ⌃ + ⌘ + Space
        ImageProfile.image = currentImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

