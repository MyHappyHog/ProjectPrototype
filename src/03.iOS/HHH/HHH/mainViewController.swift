////
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
import SwiftyDropbox

class mainViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var profileImg:UIImage = UIImage(named: "samplehog")!
    var profileName: String = "Happyhog"
    var profileMemo: String = "Happy Hedgehog House !"
    var server_addr: String? = "http://52.68.82.234:19918"
    
    var http_reference : HttpReference?
    var http_timer = NSTimer();
    
    //var now_pet = [NSManagedObject]()
    
    var index: Int?
    
    
    @IBOutlet weak var TempLabel: UILabel!
    @IBOutlet weak var HumidLabel: UILabel!
    @IBOutlet weak var ProfileImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var profileView: UIView!
    
    @IBOutlet weak var stateView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var memoView: UIView!
    
    func abc(){
        index = dataStore.profile_index
        
        let coredata = coreData(entity: "Profile")
        
        if(coredata.getCount() == 0){
            coredata.insertProfile(index!)
        }else{
            coredata.setProfile(index!)
        }
        
        setProfile()

    }
    
    override func viewDidAppear(animated: Bool) {
        setProfile()
        
        
        /*
        // Verify user is logged into Dropbox
        if let client = Dropbox.authorizedClient {
            /*
            // Get the current user's account info
            client.users.getCurrentAccount().response { response, error in
                print("*** Get current account ***")
                if let account = response {
                    //print("Hello \(account.name.givenName)!")
                } else {
                    print(error!)
                }
            }*/
            
            // List folder
            client.files.listFolder(path: "").response { response, error in
                print("*** List folder ***")
                if let result = response {
                    print("Folder contents:")
                    for entry in result.entries {
                        print(entry.name)
                    }
                } else {
                    print(error!)
                }
            }
            
            let destination : (NSURL, NSHTTPURLResponse) -> NSURL = { temporaryURL, response in
                let fileManager = NSFileManager.defaultManager()
                let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
                // generate a unique name for this file in case we've seen it before
                let UUID = NSUUID().UUIDString
                let pathComponent = "\(UUID)-\(response.suggestedFilename!)"
                return directoryURL.URLByAppendingPathComponent(pathComponent)
            }


            client.files.download(path: "/1/SensingInfo.json", destination: destination).response { response, error in
                if let (metadata, url) = response {
                    print("*** Download file ***")
                    print("Downloaded file rev: \(metadata.rev)")
                    let data = NSData(contentsOfURL: url)
                    print("-------\(NSString(data: data!, encoding: NSUTF8StringEncoding) as! String)------")
                    
                    
                    
                    let string = "{\"tempeature\": 10, \"Humidity\": 20}"
                    print(string)
                    
                    let fileData_ = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                    
                    client.files.upload(path: "/1/SensingInfo.json", mode: Files.WriteMode.Update(metadata.rev), autorename: false, clientModified: nil, mute: false, body: fileData_!)
                    
                    
                    
                } else {
                    print(error!)
                }
            }
            
            
            
            
            // Upload a file
            /*let fileData = "Hello!\ndfgsdfg".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            client.files.upload(path: "/hello.txt", body: fileData!).response { response, error in
                if let metadata = response {
                    print("*** Upload file ****")
                    print("Uploaded file name: \(metadata.name)")
                    print("Uploaded file revision: \(metadata.rev)")
                    
                    // Get file (or folder) metadata
                    client.files.getMetadata(path: "/hello.txt").response { response, error in
                        print("*** Get file metadata ***")
                        if let metadata = response {
                            if let file = metadata as? Files.FileMetadata {
                                print("This is a file with path: \(file.pathLower)")
                                print("File size: \(file.size)")
                            } else if let folder = metadata as? Files.FolderMetadata {
                                print("This is a folder with path: \(folder.pathLower)")
                            }
                        } else {
                            print(error!)
                        }
                    }
                    
                    // Download a file
                    
                    let destination : (NSURL, NSHTTPURLResponse) -> NSURL = { temporaryURL, response in
                        let fileManager = NSFileManager.defaultManager()
                        let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
                        // generate a unique name for this file in case we've seen it before
                        let UUID = NSUUID().UUIDString
                        let pathComponent = "\(UUID)-\(response.suggestedFilename!)"
                        return directoryURL.URLByAppendingPathComponent(pathComponent)
                    }
                    
                    client.files.download(path: "/hello.txt", destination: destination).response { response, error in
                        if let (metadata, url) = response {
                            print("*** Download file ***")
                            let data = NSData(contentsOfURL: url)
                            print("Downloaded file name: \(metadata.name)")
                            print("Downloaded file url: \(url)")
                            print("Downloaded file data: \(data)")
                            print("Downloaded file rev: \(metadata.rev)")
                            print("-------\(NSString(data: data!, encoding: NSUTF8StringEncoding))------")
                            

                        } else {
                            print(error!)
                        }
                    }
                    
                } else {
                    print(error!)
                }
            }*/


        }*/
    }
    
    
    func handleDidLinkNotification(notification: NSNotification) {
        print("Disconnect")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "abc", name: "asdf", object: nil)
        
        
        
        //for debuging
        //coreData.deleteAllItem("User")
        //coreData.deleteAllItem("Alarm")
        //coreData.deleteAllItem("Profile")
        
        
        //set dataStroe
        //let coredata_user = coreData(entity: "User")
        let coredata_profile = coreData(entity: "Profile")
        
        if(coredata_profile.getCount() == 0){
            
        }else{
            dataStore.profile_index = coredata_profile.getDatasIndex(0, key: "user_index") as? Int
            index = dataStore.profile_index!
            //coredata_user.getsearchIndex(coredata_profile.getDatasIndex(0, key: "name") as! String
            //                , _memo: coredata_profile.getDatasIndex(0, key: "memo") as! String
            //                , _server_addr: coredata_profile.getDatasIndex(0, key: "server_addr") as! String)
        }
        
        //start set side bar
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        //setProfile()
        
        //dropbox.setEnviromentSetting("1", maxTemperature: 30, minTemperature: 20, maxHumiidity: 50, minHumidity: 20)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.revealViewController().revealToggleAnimated(true)
        
        switch segue.identifier! {
        case "setting":
            dataStore.prev_vc = "main"
            //dataStore.profile_index = index
            break
        default:
            break
            
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////
    
    @IBAction func SettingOnClicked(sender: AnyObject) {
        //performSegueWithIdentifier("Setting", sender: self)
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
    
    @IBAction func clickFeedBtn(sender: AnyObject) {
        let alert = UIAlertController(title: "밥주기", message: "밥을 주나요?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            self.http_reference?.postFedd()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    //////////////////////////////////////////////////////////////////////////////////
    
    func checkDataForProfile(){
        if (Dropbox.authorizedClient == nil) {
            Dropbox.authorizeFromController(self)
        } else {
            print("User is already authorized!")
        }
        
        dropbox.getSensingData(server_addr!, completionHandler: {(temperature, humidity) -> Void in
            print("\(temperature)  ------ \(humidity)")
            self.TempLabel.text = (temperature == nil) ? "-- 도" : "\(String(temperature! as Int)) 도"
            self.HumidLabel.text = (humidity == nil) ? "-- %" : "\(String(humidity! as Int)) %"
        })
    }
    
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        let secondViewController = self.storyboard!.instantiateViewControllerWithIdentifier("profile") as! ProFileViewController
        
        let sVC: ProFileViewController = ProFileViewController()
        self.presentViewController(UINavigationController(rootViewController: secondViewController), animated: true, completion: nil)
        //self.navigationController!.pushViewController(secondViewController, animated: true)
    }
    
    
    
    func setGesture(){
        //start click event for profile view
        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        tap.delegate = self
        let tap1 = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        tap1.delegate = self
        
        memoView.addGestureRecognizer(tap1)
        titleView.addGestureRecognizer(tap)
        
    }
    
    func setProfile(){
        ////start get coredata
        let coredata = coreData(entity: "User")
        
        //init profile
        if coredata.getCount() == 0{
            self.nameLabel.text = "--"
            self.memoLabel.text = "--"
            self.ProfileImage.image = UIImage(named: "sampleant")
            self.server_addr = nil
        }else{
            
            self.nameLabel.text = coredata.getDatasIndex(index!, key: "title") as? String
            self.memoLabel.text = coredata.getDatasIndex(index!, key: "memo") as? String
            self.server_addr = coredata.getDatasIndex(index!, key: "server_addr") as? String
            self.ProfileImage.image = UIImage(data: (coredata.getDatasIndex(index!, key: "image") as? NSData)!)
            
            setGesture()
            checkDataForProfile()
        }
    }
}
