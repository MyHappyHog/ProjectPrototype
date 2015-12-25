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
    
    var temp_img: UIImage!
    var temp_name: String!
    var temp_memo: String!
    var isCancel: Bool = false
    
    @IBOutlet weak var CurrentProfileImage: UIImageView!
    @IBOutlet weak var NameTextField: UITextField!
    @IBOutlet weak var MemoTextField: UITextField!
    @IBOutlet weak var DeviceTextField: UITextField!
    
    
    
    @IBAction func qwe(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
   
    
    //
    
    //////
    @IBOutlet weak var cb: UIView!
    @IBOutlet weak var sdfsdfsdf: UIImageView!
    @IBOutlet weak var taaaa: UITableViewCell!
    @IBOutlet weak var profile_btn: UIButton!
    var clikedProfile = false
    
    @IBAction func profileOnCilcked(sender: AnyObject) {
        
        /*if(!clikedProfile){
        cb.hidden = true
        //taaaa.hidden = true
        clikedProfile = true
        taaaa.constraints
        }else {
        cb.hidden = false
        clikedProfile = false
        }*/
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //        if indexPath.row == 1 {
        /*let x: Int = indexPath.row
        let a = String(x)
        NSLog(a + "Aaa", indexPath.row)
        
        tableView.reloadData()*/
        //      }
        if(indexPath.row == 0){
            clikedProfile = !clikedProfile
            tableView.reloadData()
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //let x: Int = indexPath.row
        //let a = String(x)
        //NSLog(a + "abc", indexPath.row)
        if indexPath.row > 0 && indexPath.row < 5 && clikedProfile == false {
            return 0.0
        }
        /*if indexPath.row == 2 {
        if clikedProfile == false || clikedProfile == false {
        return 0.0
        }
        return 165.0
        }*/
        if indexPath.row == 1{
            return 200.0
        }
        return 44.0
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    //////
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self // Inherit UINavigationControllerDelegate
        
        CurrentProfileImage.image = profileImg
        NameTextField.text = profileName
        MemoTextField.text = profileMemo
        
        temp_img = CurrentProfileImage.image
        temp_name = NameTextField.text
        temp_memo = MemoTextField.text
        
        tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        tableView.tableFooterView = UIView(frame: CGRectZero)
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
    

    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        switch segue.identifier! {
//        case "IntroFromSetting" :
//            let nextViewController:IntroViewController = segue.destinationViewController as! IntroViewController
//            if isCancel{
//                nextViewController.profileImg = CurrentProfileImage.image!
//                nextViewController.profileName = NameTextField.text!
//                nextViewController.profileMemo = MemoTextField.text!
//            }else{
//                nextViewController.profileImg = temp_img
//                nextViewController.profileName = temp_name
//                nextViewController.profileMemo = temp_memo
//            }
//            
//            /* change to CoreData */
//            
//            break
//            
//        default:
//            break
//            
//        }
//    }
    
}
