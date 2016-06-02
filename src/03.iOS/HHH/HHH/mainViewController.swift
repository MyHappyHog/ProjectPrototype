////
//  IntroViewController.swift
//  HHHPrototype
//
//  Created by Yoonseung Choi on 2015. 10. 14..
//  Copyright © 2015년 Yoonseung Choi. All rights reserved.
//

import UIKit
import Alamofire
import Social
import YouTubePlayer
import SwiftyDropbox

class mainViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var profileImg:UIImage = UIImage(named: "tem(32)")!
    var profileName: String = "Happyhog"
    var profileMemo: String = "Happy Hedgehog House !"
    var server_addr: String? = "http://52.68.82.234:19918"
    var numRotate: Int = 1
    
    var http_reference : HttpReference?
    var http_timer = NSTimer();
    
    //var now_pet = [NSManagedObject]()
    
    var index: Int? = -1
    
    var youtubeClicked: Bool = false
    
    @IBOutlet weak var TempLabel: UILabel!
    @IBOutlet weak var HumidLabel: UILabel!
    @IBOutlet weak var ProfileImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    //@IBOutlet weak var profileView: UIView!
    
    @IBOutlet weak var stateView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var memoView: UIView!
    @IBOutlet weak var toggle: UIBarButtonItem!
    
    @IBOutlet weak var youtube: YouTubePlayerView!
    func abc(){
        index = dataStore.profile_index
        
        let coredata = coreData(entity: "Profile")
        
        if(coredata.getCount() == 0){
            if (index != nil){
                coredata.insertProfile(index!)
            }
        }else{
            coredata.setProfile(index!)
        }
        
        setProfile()

    }
    
    override func viewDidAppear(animated: Bool) {
        setProfile()
    }
    
    
    func handleDidLinkNotification(notification: NSNotification) {
        //print("Disconnect")
    }
    
    override func viewDidDisappear(animated: Bool) {
        youtube.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(mainViewController.abc), name: "asdf", object: nil)
 
        
        //youtube.loadVideoID("wQg3bXrVLtg")
        
        //Dropbox.authorizedClient = nil
        youtube.hidden = true
        
        
        //for debuging
        //coreData.deleteAllItem("User")`
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
        
        //toggle.target = self.revealViewController()
        //toggle.action = Selector("revealToggle:")
        
        //setProfile()
        
        //dropbox.setEnviromentSetting("1", maxTemperature: 30, minTemperature: 20, maxHumiidity: 50, minHumidity: 20)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //self.revealViewController().revealToggleAnimated(true)
        
        //switch segue.identifier! {
        if segue.identifier == "setting"{
            if index == -1{
                dataStore.prev_vc = "no"
            }
            else{
                dataStore.prev_vc = "main"   
            }
            //dataStore.profile_index = index
        //    break
        //default:
        //    break
            
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////
    
    
    
    
    
    
    
    
    @IBAction func SettingOnClicked(sender: AnyObject) {
        //performSegueWithIdentifier("Setting", sender: self)
        if index == -1{
            return
        }
    }
    
    @IBAction func clickVideo(sender: AnyObject) {
        if index == -1{
            return
        }
        //self.navigationController?.revealViewController().revealToggleAnimated(true)
        if youtubeClicked {
            youtube.hidden = true
            youtubeClicked = false
        }else{
            let alert = UIAlertController(title: "실시간 동영상", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            //alert.addTextFieldWithConfigurationHandler(configurationTextField)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
                
                var path: String?
            
                if (Dropbox.authorizedClient == nil) {
                    Dropbox.authorizeFromController(self)
                } else {
                    print("User is already authorized!")
                }
            
                if let client = Dropbox.authorizedClient{
                        let destination : (NSURL, NSHTTPURLResponse) -> NSURL = { temporaryURL, response in
                        let fileManager = NSFileManager.defaultManager()
                        let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
                            // generate a unique name for this file in case we've seen it before
                            let UUID = NSUUID().UUIDString
                            let pathComponent = "\(UUID)-\(response.suggestedFilename!)"
                            return directoryURL.URLByAppendingPathComponent(pathComponent)
                    }
                    let temp = "live"//((self.tField.text! as String).componentsSeparatedByString(".url"))
                    //print("/\(temp[0]).url")
                    
                    client.files.download(path: "/\(temp).url", destination: destination).response { response, error in
                        if let (metadata, url) = response {
                            print("*** Download file ***")
                            let data = NSData(contentsOfURL: url)
                            print(NSString(data: data!, encoding: NSUTF8StringEncoding) as! String)
                            let a = (NSString(data: data!, encoding: NSUTF8StringEncoding) as! String).componentsSeparatedByString("\n")
                            let index = a[1].startIndex.advancedBy(4)
                            path = a[1].substringFromIndex(index) as String
                            print(path! as String)
                        
                            self.youtube.hidden = false
                        
                            if(path != nil){
                                let myVideoURL = NSURL(string: path!)
                                self.youtube.loadVideoURL(myVideoURL!)
                                self.youtube.play()
                                self.youtubeClicked = true
                            }
                        } else {
                            print(error!)
                        }

                    }
                }
            }))
        
            alert.addAction(UIAlertAction(title: "Cancel", style: .Destructive, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
        
            presentViewController(alert, animated: true, completion: nil)
        }

    }
    var tField: UITextField!
    func configurationTextField(textField: UITextField!)
    {
        print("generating the TextField")
        textField.placeholder = ""
        tField = textField
    }
    
    @IBAction func clickShareBtn(sender: AnyObject) {
        if index == -1{
            return
        }
        //self.revealViewController().revealToggleAnimated(true)
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
    
    @IBAction func clickToggle(sender: AnyObject) {
        self.navigationController?.revealViewController().revealToggleAnimated(true)
        //self.revealViewController().Selector("reavelToggle:")
    }
    @IBAction func clickFeedBtn(sender: AnyObject) {
        if index == -1{
            return
        }
        let alert = UIAlertController(title: "밥주기", message: "밥을 주나요?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler { (obj) -> Void in
            //a.text = self.text_server1
            //self.server1_temp = a.text
            //print(a.text)
            //obj.delegate = self
            obj.keyboardType = .NumberPad

        }
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            //self.http_reference?.postFedd()
            //let _rotate = Int(self.tField.text! as String)
            let a = alert.textFields![0] as UITextField
            let _rotate = Int(a.text! as String)//self.numRotate
            let rotate = (_rotate == nil) ? 1 : _rotate
            
            print(_rotate)
            
            dropbox.putTheFeed(self.server_addr!, rotate: rotate!)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Destructive, handler: { (action: UIAlertAction!) in
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
            self.TempLabel.text = (temperature == nil) ? "-- 도" : "\(String(temperature! as Double)) 도"
            self.HumidLabel.text = (humidity == nil) ? "-- %" : "\(String(humidity! as Double)) %"
        })
    }
    
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        dataStore.prev_vc = "main"
        
        let secondViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ProFile") as! ProFileViewController
        
        //let sVC: ProFileViewController = ProFileViewController()
        self.presentViewController(UINavigationController(rootViewController: secondViewController), animated: true, completion: nil)
        //self.navigationController!.pushViewController(secondViewController, animated: true)
    }
    
    
    
    func setGesture(){
        //start click event for profile view
        let tap = UITapGestureRecognizer(target: self, action: #selector(mainViewController.handleTap(_:)))
        tap.delegate = self
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(mainViewController.handleTap(_:)))
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
            self.server_addr = coredata.getDatasIndex(index!, key: "server_addr1") as? String
            self.ProfileImage.image = UIImage(data: (coredata.getDatasIndex(index!, key: "image") as? NSData)!)
            self.numRotate = coredata.getDatasIndex(index!, key: "numRotate") as! Int
            
            setGesture()
            checkDataForProfile()
        }
    }
}
