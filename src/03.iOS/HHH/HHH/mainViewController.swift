//
//  IntroViewController.swift
//  HHHPrototype
//
//  Created by Yoonseung Choi on 2015. 10. 14..
//  Copyright © 2015년 Yoonseung Choi. All rights reserved.
//

import UIKit
import Alamofire
import Kanna
import Social

class mainViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var profileImg:UIImage = UIImage(named: "samplehog")!
    var profileName: String = "Happyhog"
    var profileMemo: String = "Happy Hedgehog House !"
    var server_addr: String? = "http://52.68.82.234:19918"
    
    var http_reference : HttpReference?
    var http_timer = NSTimer();
    
    //var now_pet = [NSManagedObject]()
    
    
    
    @IBOutlet weak var TempLabel: UILabel!
    @IBOutlet weak var HumidLabel: UILabel!
    @IBOutlet weak var ProfileImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var profileView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //for debuging
        //coreData.deleteAllItem()
        
        
        //set dataStroe
        let coredata_user = coreData(entity: "User")
        let coredata_profile = coreData(entity: "Profile")
        
        
        if(coredata_profile.getCount() == 0){
            dataStore.index = nil
        }else{
            dataStore.index = coredata_user.getsearchIndex(coredata_profile.getDatasIndex(0, key: "name") as! String
                , _memo: coredata_profile.getDatasIndex(0, key: "memo") as! String
                , _server_addr: coredata_profile.getDatasIndex(0, key: "server_addr") as! String)
            
        }
        
        
        //start click event for profile view
        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        tap.delegate = self
        profileView.addGestureRecognizer(tap)

        //start set side bar
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        
        
        ProfileImage.image = profileImg
        memoLabel.text = profileMemo
        nameLabel.text = profileName
        
        ////start get coredata
        let coredata = coreData(entity: "User")
        
        //init profile
        if coredata.getCount() == 0{
            self.nameLabel.text = "--"
            self.memoLabel.text = "--"
            self.ProfileImage.image = UIImage(named: "sampleant")
            self.server_addr = nil
        }else{
            self.nameLabel.text = coredata.getDatasIndex(0, key: "title") as? String
            self.memoLabel.text = coredata.getDatasIndex(0, key: "memo") as? String
            self.server_addr = coredata.getDatasIndex(0, key: "server_addr") as? String
            self.ProfileImage.image = UIImage(data: (coredata.getDatasIndex(0, key: "image") as? NSData)!)
        
            checkDataForProfile()
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.revealViewController().revealToggleAnimated(true)
        
        switch segue.identifier! {
        case "setting":
            dataStore.index = 0
            break
        default:
            break
            
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////
    
    @IBAction func SettingOnClicked(sender: AnyObject) {
        performSegueWithIdentifier("Setting", sender: self)
    }
    
    
    
    @IBAction func clickShareBtn(sender: AnyObject) {
                self.revealViewController().revealToggleAnimated(true)
        //
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookSheet.setInitialText("Share on Facebook")
            self.presentViewController(facebookSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////
    
    func checkDataForProfile(){
        if server_addr != nil {
            http_reference = HttpReference(server_addr)
            
            //http_reference?.postSensorData(20, minTemprature: 15, maxHumidity: 70, minHumidity: 10)
            
            //타이머 시간 설정
            let http_timer_interval:NSTimeInterval = 50.0
            
            //타이머를 설정해주면 처음 시작도 정해진 시간뒤여서 우선 맨처음 실행 후 타잇=머 설정
            getHttpMsg();
            
            http_timer = NSTimer.scheduledTimerWithTimeInterval(http_timer_interval, target: self, selector:  "getHttpMsg", userInfo:  nil, repeats: true)
        }
        
    }
    
    func getHttpMsg(){
        http_reference!.getResponse({(result, temperature, humidity) -> Void in
            if(result == true){
                //self.TempLabel.text = self.http_reference!.getData(0)
                //self.HumidLabel.text = self.http_reference!.getData(1)
                self.TempLabel.text = temperature
                self.HumidLabel.text = humidity
            }else{
                self.TempLabel.text = temperature
                self.HumidLabel.text = humidity
                return
            }
        })
    }

    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        let secondViewController = self.storyboard!.instantiateViewControllerWithIdentifier("profile") as! ProFileViewController
        
        self.navigationController!.pushViewController(secondViewController, animated: true)
    }
}

