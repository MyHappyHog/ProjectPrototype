//
//  IntroViewController.swift
//  HHHPrototype
//
//  Created by Yoonseung Choi on 2015. 10. 14..
//  Copyright © 2015년 Yoonseung Choi. All rights reserved.
//

import UIKit
import CoreData
//usage
//http://www.raywenderlich.com/85080/beginning-alamofire-tutorial
//github
//https://github.com/Alamofire/Alamofire
import Alamofire
//github
//https://github.com/drmohundro/SWXMLHash
import SWXMLHash
//github
//https://github.com/tid-kijyun/Kanna
import Kanna


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
        
        let data_thread = NSThread(target: self, selector: "setData", object: nil)
        data_thread.start();
        
        
    }
    
    func setData(){
        // 취소되기 전까지 무한루프
        while NSThread.currentThread().cancelled == false {
            
            
            //get http source
            //use Alamofire library
            Alamofire.request(.GET, "http://52.68.82.234:19918")
                .responseString { response in
                    print("Success: \(response.result.isSuccess)")
                    print("Response String: \(response.result.value)     ")
                    
                    //var xml = SWXMLHash.parse(response.result.value!)
                    
                    //let count = xml["html"].all.count
                    
                    //print("Count     \(count)")
                    
                    
                    
                    if let doc = Kanna.HTML(html: response.result.value!, encoding: NSUTF8StringEncoding) {
                        print("TITLE: \(doc.title)")
                        
                        
                        // Search for nodes by CSS
                        /*for link in doc.css("p") {
                            print("text === \(link.text)")
                            //print("ㅎㄱㄷㄹ == \(link["class"])")
                        }*/
                        
                        let data_string = doc.css("p").at(1)?.text
                        
                        
                        let data_string_split = data_string!.componentsSeparatedByString(" / ")
                        let tem_string = data_string_split[0], humid_string = data_string_split[1];
                        
                        let tem = tem_string.componentsSeparatedByString(": ")
                        let humid = humid_string.componentsSeparatedByString(": ")
                        
                        self.TempLabel.text = tem[1] + "도"
                        self.HumidLabel.text = humid[1] + "%"
                        
                    }
                    
                    
            }
            
            // 1초간 휴식
            NSThread.sleepForTimeInterval(30)
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
        case "Web":
            
            break;
        default:
            break
            
        }
    }
    
}

