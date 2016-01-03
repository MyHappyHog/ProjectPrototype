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


class mainViewController: UIViewController {
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ProfileImage.image = profileImg
        
        
        memoLabel.text = profileMemo
        nameLabel.text = profileName
        //TitleLabel.title = profileName
        
        
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        //self.revealViewController().panGestureRecognizer().enabled = true
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        
        
        //insert core data
        let userEntity = NSEntityDescription.entityForName("User", inManagedObjectContext: managedObjectContext!)
        
        /*let contact = User(entity: userEntity!, insertIntoManagedObjectContext: managedObjectContext!)
        contact.title = "고슴도치"
        contact.memo = "내꺼"
        contact.image = "sampleHog"*/
        
        do{
            //try managedObjectContext?.save()
        }catch{
            print(error)
        }
        
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
                //deleteAllItem()
            }
        }catch{
            print(error)
        }
        
        settingProfile()
        
        
    }
    
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
                try context.save() } } catch {}
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

