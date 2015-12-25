//
//  IntroViewController.swift
//  HHHPrototype
//
//  Created by Yoonseung Choi on 2015. 10. 14..
//  Copyright © 2015년 Yoonseung Choi. All rights reserved.
//

import UIKit
//import CoreData
import Alamofire
import Kanna


class mainViewController: UIViewController {
    
    var profileImg:UIImage = UIImage(named: "samplehog")!
    var profileName: String = "Happyhog"
    var profileMemo: String = "Happy Hedgehog House !"
    var server_addr: String = "http://52.68.82.234:19918"
    
    var http_reference : HttpReference?
    var http_timer = NSTimer();
    
    //var now_pet = [NSManagedObject]()
    
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var MemoLabel: UILabel!
    
    @IBOutlet weak var TitleLabel: UINavigationItem!
    @IBOutlet weak var TempImage: UIImageView!
    @IBOutlet weak var TempLabel: UILabel!
    
    @IBOutlet weak var HumidImage: UIImageView!
    @IBOutlet weak var HumidLabel: UILabel!
    
    @IBOutlet weak var LightImage: UIImageView!
    
    @IBOutlet weak var ProfileImage: UIImageView!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ProfileImage.image = profileImg
        
        
        MemoLabel.text = profileMemo
        //NameLabel.text = profileName
        TitleLabel.title = profileName
        
        
        
        
        
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        //self.revealViewController().panGestureRecognizer().enabled = true
        
        http_reference = HttpReference(server_addr)
        
        //타이머 시간 설정
        let http_timer_interval:NSTimeInterval = 10.0
        
        //타이머를 설정해주면 처음 시작도 정해진 시간뒤여서 우선 맨처음 실행 후 타잇=머 설정
        sendHttpGet();
        
        http_timer = NSTimer.scheduledTimerWithTimeInterval(http_timer_interval, target: self, selector:  "sendHttpGet", userInfo:  nil, repeats: true)
        
    }
    
    func sendHttpGet(){
        http_reference!.getResponse({(result, temperature, humidity) -> Void in
            if(result == true){
                //self.TempLabel.text = self.http_reference!.getData(0)
                //self.HumidLabel.text = self.http_reference!.getData(1)
                self.TempLabel.text = temperature
                self.HumidLabel.text = humidity
            }else{
                return
            }
        })
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
            
            http_timer.invalidate()
            
            
            //            let destinationNavigationController = segue.destinationViewController as! UINavigationController
            //            let nextViewController = destinationNavigationController.topViewController as! SettingViewController//segue.destinationViewController as! SettingViewController
            //            nextViewController.profileImg = ProfileImage.image
            //            nextViewController.profileName = NameLabel.text
            //            nextViewController.profileMemo = MemoLabel.text
            
            //core data save
            
            
            break
        case "Web":
            
            break;
        default:
            break
            
        }
        print("aaawerwera")
    }
    
}

