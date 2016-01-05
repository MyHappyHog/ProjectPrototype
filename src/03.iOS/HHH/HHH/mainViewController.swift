//
//  IntroViewController.swift
//  HHHPrototype
//
//  Created by Yoonseung Choi on 2015. 10. 14..
//  Copyright © 2015년 Yoonseung Choi. All rights reserved.
//

import UIKit
import CoreData
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
    
    
    override func viewWillDisappear(animated: Bool) {
        http_timer.invalidate()
    }
    override func viewWillAppear(animated: Bool) {
        settingProfile()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //start click event for profile view
        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        tap.delegate = self
        profileView.addGestureRecognizer(tap)
        //end click event for profile view
        
        ProfileImage.image = profileImg
        memoLabel.text = profileMemo
        nameLabel.text = profileName
        
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        //insert core data
        /*let userEntity = NSEntityDescription.entityForName("User", inManagedObjectContext: managedObjectContext!)
        
        let contact = User(entity: userEntity!, insertIntoManagedObjectContext: managedObjectContext!)
        contact.title = "개미개미"
        contact.memo = "내꺼"
        contact.image = "sampleant"
        contact.server_addr = "http://52.68.82.234:19918"
        
        do{
            try managedObjectContext?.save()
        }catch{
            print(error)
        }*/
        
        //get core data
        let entityDescription = NSEntityDescription.entityForName(/*"Profile"*/"User", inManagedObjectContext: managedObjectContext!)
        
        let request = NSFetchRequest()
        request.entity = entityDescription
        
        //let pred = NSPredicate(format: "(title = %@)", TitleLabel.text)
        //request.predicate = pred

        
        do{
            var objects = try managedObjectContext!.executeFetchRequest(request)

            print(objects.count)
            
            if objects.count == 0{
                self.nameLabel.text = "--"
                self.memoLabel.text = "--"
                self.ProfileImage.image = UIImage(named: "sampleant")
                self.server_addr = nil
            }else{
                let value = objects[0] as! NSManagedObject
                self.nameLabel.text = value.valueForKey("title") as? String
                self.memoLabel.text = value.valueForKey("memo") as? String
                self.server_addr = value.valueForKey("server_addr") as? String
                self.ProfileImage.image = UIImage(named: (value.valueForKey("image") as? String)!)
                //deleteAllItem()
                
                settingProfile()
            }
        }catch{
            print(error)
        }
    }
    
    //for debuging
    func deleteAllItem(){
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "User")
        request.returnsObjectsAsFaults = false
        
        do {
            let incidents = try context.executeFetchRequest(request)
            
            if incidents.count > 0 {
                
                for result: AnyObject in incidents{
                    context.deleteObject(result as! NSManagedObject)
                    print("NSManagedObject has been Deleted")
                }
                try context.save()
            }
        } catch {}
    }

    
    func settingProfile(){
        if server_addr != nil {
        http_reference = HttpReference(server_addr)
        
        
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func SettingOnClicked(sender: AnyObject) {
        performSegueWithIdentifier("Setting", sender: self)
    }
    
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        let secondViewController = self.storyboard!.instantiateViewControllerWithIdentifier("profile") as! ProFileViewController
        
        self.navigationController!.pushViewController(secondViewController, animated: true)
        
    }
    @IBAction func clickShareBtn(sender: AnyObject) {
                self.revealViewController().revealToggleAnimated(true)
        
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.revealViewController().revealToggleAnimated(true)
        
        switch segue.identifier! {
        case "Setting":
            
            break
        default:
            break
            
        }
    }
}

