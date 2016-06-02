//
//  settingViewController.swift
//  HHH
//
//  Created by Cho YoungHun on 2016. 3. 30..
//  Copyright © 2016년 hhh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyDropbox
import SystemConfiguration.CaptiveNetwork

class settingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate{
    var prev_vc :String?
    var index: Int?

    @IBOutlet weak var profileImage: UIImageView!
    
    let imgPicker = UIImagePickerController()
    
    
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var feedingBtn: UIButton!
    @IBOutlet weak var sensorBtn: UIButton!
    
    func setOutline(obj: UIButton){
        obj.backgroundColor = UIColor.clearColor()
        //settingBtn.layer.cornerRadius = 5
        obj.layer.borderWidth = 1
        obj.layer.borderColor = UIColor.blackColor().CGColor

    }
    
    override func viewDidAppear(animated: Bool) {
        profileImage.image = dataStore.temp_user?.image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgPicker.delegate = self
        
        setOutline(profileBtn)
        setOutline(feedingBtn)
        setOutline(sensorBtn)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(settingViewController.handleTap(_:)))
        tap.delegate = self
        profileImage.userInteractionEnabled = true
        profileImage.addGestureRecognizer(tap)
        
        prev_vc = dataStore.prev_vc
        
        if prev_vc == "no"{
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        if prev_vc == "main"{
            let coredata = coreData(entity: "User")
            index = dataStore.profile_index
            if(coredata.getCount() != 0){
                self.profileImage.image = UIImage(data: coredata.getDatasIndex(index!, key: "image") as! NSData)
                print(String(coredata.getDatasIndex(index!, key: "numRotate") as? Int))
            }
            dataStore.temp_user = data_user(image: self.profileImage.image!, name: coredata.getDatasIndex(index!, key: "title") as! String,
                memo: coredata.getDatasIndex(index!, key: "memo") as! String,
                server: coredata.getDatasIndex(index!, key: "server_addr1") as! String,
                server1: coredata.getDatasIndex(index!, key: "server_addr2") as! String,
                minTemp: coredata.getDatasIndex(index!, key: "minTemp") as! Int,
                maxTemp: coredata.getDatasIndex(index!, key: "maxTemp") as! Int,
                minHumid: coredata.getDatasIndex(index!, key: "minhum") as! Int,
                maxHumid: coredata.getDatasIndex(index!, key: "maxhum") as! Int,
                temperature_index: coredata.getDatasIndex(index!, key: "temperature_index") as! Int,
                humidity_index: coredata.getDatasIndex(index!, key: "humidity_index") as! Int,
                numRotate: coredata.getDatasIndex(index!, key: "numRotate") as! Int)

        }else{ //add
            //사이드바에서 설정해둠
            index = dataStore.numOfUser
            dataStore.temp_user = data_user(image: UIImage(named: "default_6")!, name: "init", memo: "init", server: "init", server1: "init", minTemp: 0, maxTemp: 0, minHumid: 0, maxHumid: 0, temperature_index: 0, humidity_index: 1, numRotate: 0)
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let id = segue.identifier
        
        if id == "feed"{
            if(dataStore.parserTime != ""){
                return
            }
            
            let alarmData = coreData(entity: "Alarm")
            
            var parser: String = ""
            //let index = dataStore.now_index
            if index == nil{
                index = 0
            }
            
            print("-----start prepareFor segue")
            let startIndex = alarmData.getStartTimer(index!)
            for(var i = 0; i < alarmData.getCountTimer(index!); i++){
                parser += alarmData.getDatasIndex(startIndex + i, key: "time") as! String
                parser += "@"
                parser += String(alarmData.getDatasIndex(startIndex + i, key: "num") as! Int)
                parser += ";"
                
                print(parser)
            }
            if(parser != ""){
//                parser.removeAtIndex(parser.endIndex - 1)
                parser.removeAtIndex(parser.endIndex.predecessor())
            }
            dataStore.parserTime = parser
            print("-----end prepareFor segue")

        }
    }
    
    @IBAction func clickSave(sender: AnyObject) {
        //self.firstConnectWifi()
        self.saveData()
        dataStore.parserTime = ""
        dataStore.prev_vc = "else"
        dataStore.temp_user = nil
        
        if prev_vc == "add"{
            firstConnectWifi()
        }
        
    }
    
    @IBAction func clickCancel(sender: AnyObject) {
        dataStore.prev_vc = "else"
        dataStore.parserTime = ""
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func clickProfile(sender: AnyObject) {
        if dataStore.prev_vc != "add"{
            dataStore.prev_vc = "setting"
        }
        let secondViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ProFile") as! ProFileViewController
        self.presentViewController(UINavigationController(rootViewController: secondViewController), animated: true, completion: nil)
    }
    
    
    
    var check_alert: Bool = false
    var check_wifi: Bool = false
    
    func firstConnectWifi(){
        let alert = UIAlertController(title: "첫번째 WIFI에 연결해주세요", message: "연결이 완료가 되면 확인 버튼을 눌러주세요.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "준비완료", style: .Default, handler: {(action: UIAlertAction!) in
            self.firstSendMessage()
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    var text_wifi_id: UITextField!, text_wifi_password: UITextField!, text_relay_addr: UITextField!
    var wifi_id: String = "", wifi_password: String = "", relay_addr: String = ""
    
    
    func firstSendMessage(){
        let alert = UIAlertController(title: "사용하실 WIFI를 입력해주세요.", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler { (a) -> Void in
            a.placeholder = "WIFI 이름"
            self.text_wifi_id = a
        }
        alert.addTextFieldWithConfigurationHandler { (b) -> Void in
            b.placeholder = "WIFI 비밀번호"
            self.text_wifi_password = b
        }
        alert.addTextFieldWithConfigurationHandler { (c) -> Void in
            c.placeholder = "RELAY 주소"
            self.text_relay_addr = c
        }
        alert.addAction(UIAlertAction(title: "입력완료", style: .Default, handler: {(action: UIAlertAction!) in
            self.wifi_id = self.text_wifi_id.text! as String
            self.wifi_password = self.text_wifi_password.text! as String
            self.relay_addr = self.text_relay_addr.text! as String
            print("\(self.wifi_id)   \(self.wifi_password)")
            
            self.sendServer()
            //self.saveData()
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        
        presentViewController(alert, animated: true, completion: nil)
    }

    
    func sendServer(){
        let coredata_token = coreData(entity: "Token")
        let token: String = coredata_token.getDatasIndex(0, key: "token") as! String
        
        Alamofire.request(.POST, "http://192.168.4.1:12345", parameters: [
            "ssid": self.wifi_id,
            "password": self.wifi_password,
            "dropboxKey": token,
            "relayMac": self.relay_addr])
    }
    
    func saveData(){
        self.insertTime()
        let coredata = coreData(entity: "User")
        
        if prev_vc == "add"{
            coredata.insertData(dataStore.temp_user!)
            if(coredata.getCount() == 0){
                dataStore.profile_index = 0
                NSNotificationCenter.defaultCenter().postNotificationName("asdf", object: self)
            }
        }else{
            coredata.setUserData(dataStore.temp_user!, index: index!)
        }
        
        save_dropbox()
    }
    
    func insertTime(){
        print("index ---------------")
        print(index)
        /*
        *   알람 삭제
        */
        let _coredata = coreData(entity: "Alarm")
        for(var i = _coredata.getCount()! - 1; i >= 0 ; i -= 1){
            let data_index: Int = _coredata.getDatasIndex(i, key: "user_number") as! Int
            if data_index == index{
                coreData.deleteItem("Alarm", index: i)
            }/*else if data_index > index{
                _coredata.setTimer(i, num: data_index - 1)
            }*/
        }
        let coredata = coreData(entity: "Alarm")

        
        if dataStore.parserTime == ""{
            dropbox.putSchedule((dataStore.temp_user?.server_addr1)!, data: "")
            return
        }
        print("-----start insertTime")
        
        var foodJson: String = "["
        /////알람 다 삭제하고 하기
                let data = dataStore.parserTime
        print(data)
        //let index: Int? = dataStore.now_index
        let arrFull = data.componentsSeparatedByString(";")
        print(arrFull.count)
        print(arrFull)
        for(var i = 0; i < arrFull.count; i += 1){
            if arrFull[i] == ""{
                print("in")
                continue
            }
            print(arrFull[i])
            let temp = arrFull[i].componentsSeparatedByString("@")
            print(temp)
            let time:String = temp[0] as String
            let num: Int = Int(temp[1] as String)!
            
            var hour:Int = Int(time.componentsSeparatedByString(":")[0].componentsSeparatedByString(" ")[1] as String)!
            let min = Int(time.componentsSeparatedByString(":")[1] as String)!
            
            if time.componentsSeparatedByString(" ")[1] == "PM"{
                hour += 12;
            }
            
            foodJson += "{\"numRotate\": \(num), \"time\": \"\(String(hour as Int)):\(String(min as Int))\"}"
            if i != arrFull.count - 2{
                foodJson += ", "
            }
            
            coredata.insertTimer(time, num: num, index: index!)
        }
        foodJson += "]"
        
        //if arrFull.count > 2{
            dropbox.putSchedule((dataStore.temp_user?.server_addr1)!, data: foodJson)
        //}
        print("-----end insertTime")
    }
    
    func save_dropbox(){
        //Dropbox.authorizedClient = nil
        
        if (Dropbox.authorizedClient == nil) {
            Dropbox.authorizeFromController(self)
        } else {
            print("User is already authorized!")
            
        }
        
        
        if (Dropbox.authorizedClient != nil) {
            let User = dataStore.temp_user
            dropbox.setEnviromentSetting((User?.server_addr2!)!,//serverTxt.text!,
                maxTemperature: (User?.maxTemp)!,//Int(textfieldMaxTemp.text! as String)!,
                minTemperature: (User?.minTemp)!,//Int(textfieldMinTemp.text! as String)!,
                maxHumiidity:   (User?.maxHumid)!,//Int(textfieldMaxHumi.text! as String)!,
                minHumidity:    (User?.minHumid)!)//Int(textfieldMinHumi.text! as String)!)
            
            dropbox.setRelaySetting((User?.server_addr2)!,//serverTxt.text!
                temp: (User?.temperature_index)!, humidity: (User?.humidity_index)!)
        }
    }
    
    
    /*
    *   click image
    */
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        imgPicker.allowsEditing = false
        imgPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(imgPicker, animated: true, completion: nil)
    }
    
    /* change the profile image when user choose the new profile image in the photo library */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let imageUrl          = info[UIImagePickerControllerReferenceURL] as! NSURL
        let imageName : String    = imageUrl.lastPathComponent!
        dataStore.extenstion = imageName
        //print(imageName)
        
        let newImage: UIImage
        
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        
        //self.image = newImage
        self.profileImage.image = newImage//self.image
        dataStore.temp_user?.image = newImage
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    /* did not change the profile image when user choose the cancel in the photo library */
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    *   get wifi id
    */
    /*func fetchSSIDInfo() ->  String {
        var currentSSID = ""
        if let interfaces:CFArray! = CNCopySupportedInterfaces() {
            for i in 0..<CFArrayGetCount(interfaces){
                let interfaceName: UnsafePointer<Void> = CFArrayGetValueAtIndex(interfaces, i)
                let rec = unsafeBitCast(interfaceName, AnyObject.self)
                let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)")
                if unsafeInterfaceData != nil {
                    let interfaceData = unsafeInterfaceData! as Dictionary!
                    currentSSID = interfaceData["SSID"] as! String
                }
            }
        }
        return currentSSID
    }*/
}
