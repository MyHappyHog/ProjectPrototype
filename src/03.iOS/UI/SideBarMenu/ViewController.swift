//
//  ViewController.swift
//  SideBarMenu
//
//  Created by Alexandre on 30/01/2015.
//  Copyright (c) 2015 Alexandre. All rights reserved.
//

import UIKit
import Social
import AVKit
import AVFoundation

class ViewController: UIViewController, SideBarDelegate {
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileMemo: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var hideView: UIView!
    @IBOutlet weak var AVPlayerView: UIView!
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    @IBAction func videoStream(sender: AnyObject) {
                
    }
    
    var sideBar:SideBar = SideBar()
    var nameLabelText:String?
    var memoLabelText:String?
    var images: UIImage?
    
    override func viewDidLoad() {
        
        //side bar setting
        hideView.hidden = true
        hideView.backgroundColor = UIColor.grayColor()
        hideView.alpha = 0.6

        sideBar = SideBar(sourceView: self.view, menuItems: ["first item", "second item", "funny item"])
        sideBar.delegate = self
        
        //name, memo change setting
        profileName.text = nameLabelText
        profileMemo.text = memoLabelText
        profileImage.image = images
        
    }
    
    //change the main name, memo
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController as? ProfileViewController
        destination!.nameLabelText = profileName.text
        destination!.memoLabelText = profileMemo.text
        destination!.images = profileImage.image
    }
    func sideBarDidSelectButtonAtIndex(index: Int) { //which menuitem you take
        if index == 2 {
           // imageView.backgroundColor   = UIColor.redColor()
            //imageView.image             = nil
        } else if index == 0 {
            //imageView.image = UIImage(named: "stars")
        }
    }
    
    func sideBarWillOpen() {
        hideView.hidden = false
    }
    
    func sideBarWillClose() {
        hideView.hidden = true
    }

    //share on facebook
    @IBAction func shareToFacebook() {
        let shareToFacebook : SLComposeViewController =
        SLComposeViewController(forServiceType:
        SLServiceTypeFacebook)
        self.presentViewController(shareToFacebook, animated:
            true, completion: nil)
    }

}

