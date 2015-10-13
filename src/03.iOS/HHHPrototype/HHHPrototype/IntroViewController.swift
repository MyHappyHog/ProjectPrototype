//
//  IntroViewController.swift
//  HHHPrototype
//
//  Created by Yoonseung Choi on 2015. 10. 14..
//  Copyright © 2015년 Yoonseung Choi. All rights reserved.
//

import UIKit
import CoreData

class IntroViewController: UIViewController {

    var profileImg:UIImage = UIImage(named: "samplehog")!
    var profileName: String = "Happyhog"
    var profileMemo: String = "Happy Hedgehog House !"
    
    
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var MemoLabel: UILabel!
    
    @IBOutlet weak var TempImage: UIImageView!
    @IBOutlet weak var TempLabel: UILabel!
    
    @IBOutlet weak var HumidImage: UIImageView!
    @IBOutlet weak var HumidLabel: UILabel!
    
    @IBOutlet weak var LightImage: UIImageView!
    
    @IBOutlet weak var ProfileImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ProfileImage.image = profileImg
        NameLabel.text = profileName
        MemoLabel.text = profileMemo
        
        
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func SettingOnClicked(sender: AnyObject) {
        performSegueWithIdentifier("Setting", sender: self)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        switch segue.identifier! {
        case "Setting":
            let nextViewController = segue.destinationViewController as! SettingViewController
            nextViewController.profileImg = ProfileImage.image
            nextViewController.profileName = NameLabel.text
            nextViewController.profileMemo = MemoLabel.text
            break
            
        default:
            break
            
        }
    }

}

