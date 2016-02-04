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
    
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        print("change")
    }
    func abc(){
        print("abc")
        index = dataStore.index
        
        let coredata = coreData(entity: "Profile")
        
        if(coredata.getCount() == 0){
            coredata.insertProfile(index!)
        }else{
            coredata.setProfile(index!)
        }
        
        print(index)
        setProfile()
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
            dataStore.index = nil
            index = 0
        }else{
            dataStore.index = coredata_profile.getDatasIndex(0, key: "user_index") as? Int
            index = dataStore.index!
            //coredata_user.getsearchIndex(coredata_profile.getDatasIndex(0, key: "name") as! String
//                , _memo: coredata_profile.getDatasIndex(0, key: "memo") as! String
//                , _server_addr: coredata_profile.getDatasIndex(0, key: "server_addr") as! String)
            
        }
        print(index)
        
        //start set side bar
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        
        setProfile()
        
        //ProfileImage.image = ProfileImage.image?.resized(CGSizeMake(19, 19))
        //ProfileImage.image = CGSize(width: 50.0, height: 50.0)
        print(ProfileImage.frame.height)
        //ProfileImage.frame = CGRectMake(ProfileImage.frame.origin.x, ProfileImage.frame.origin.y, 200, 200)
        print(ProfileImage.frame.height)
       // ProfileImage.frame.    
        
        //ProfileImage.frame = CGRectMake(0,0,50.0, 050.0);
        //ProfileImage.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        //ProfileImage.image = RBSquareImageTo(ProfileImage.image!, size: CGSize(width: 200, height: 200))
    }
    

    
    
    func RBSquareImageTo(image: UIImage, size: CGSize) -> UIImage {
        return RBResizeImage(RBSquareImage(image), targetSize: size)
    }
    
    func RBSquareImage(image: UIImage) -> UIImage {
        var originalWidth  = image.size.width
        var originalHeight = image.size.height
        
        var edge: CGFloat
        if originalWidth > originalHeight {
            edge = originalHeight
        } else {
            edge = originalWidth
        }
        
        var posX = (originalWidth  - edge) / 2.0
        var posY = (originalHeight - edge) / 2.0
        
        var cropSquare = CGRectMake(posX, posY, edge, edge)
        
        var imageRef = CGImageCreateWithImageInRect(image.CGImage, cropSquare);
        return UIImage(CGImage: imageRef!, scale: UIScreen.mainScreen().scale, orientation: image.imageOrientation)
    }
    
    func RBResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
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
            dataStore.index = index
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


extension UIImage {
    
    func resized(newSize:CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.mainScreen().scale)
        self.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

