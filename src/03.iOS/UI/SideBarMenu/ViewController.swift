//
//  ViewController.swift
//  SideBarMenu
//
//  Created by Alexandre on 30/01/2015.
//  Copyright (c) 2015 Alexandre. All rights reserved.
//

import UIKit
import Social

class ViewController: UIViewController, SideBarDelegate {

    @IBOutlet weak var backgroundView: UIView!
  //  @IBOutlet weak var imageView: UIImageView!
    
    var sideBar:SideBar = SideBar()
    
    override func viewDidLoad() { //show side bar or not

        sideBar = SideBar(sourceView: self.view, menuItems: ["first item", "second item", "funny item"])
        sideBar.delegate = self
    }
    
    func sideBarDidSelectButtonAtIndex(index: Int) { //which menuitem you take
        if index == 2 {
           // imageView.backgroundColor   = UIColor.redColor()
            //imageView.image             = nil
        } else if index == 0 {
            //imageView.image = UIImage(named: "stars")
        }
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

