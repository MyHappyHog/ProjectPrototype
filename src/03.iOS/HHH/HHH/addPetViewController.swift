//
//  SettingViewController.swift
//  HHHPrototype
//
//  Created by Yoonseung Choi on 2015. 10. 14..
//  Copyright © 2015년 Yoonseung Choi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyDropbox
import SystemConfiguration.CaptiveNetwork


class addPetViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    //var isExpanding : Bool = false
    var clickForExpanding = [false, false, false, false]
    var cellHeightArray : [CGFloat] = [0.0, 400.0, 200.0, 150.0]
    var now_expanding : Int = -1
    var num_expanded : Int = 0
    
    let imgPicker = UIImagePickerController()
    //var image :UIImage = UIImage(named: "temp(32)")!
    
    var index: Int?
    var main_addr: String? = "foo"
    var relay_addr: String? = " foo"
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var memoTxt: UITextField!
    @IBOutlet weak var serverTxt: UITextField!
    //
    @IBOutlet weak var textfieldMinTemp: UITextField!
    @IBOutlet weak var textfieldMaxTemp: UITextField!
    @IBOutlet weak var textfieldMinHumi: UITextField!
    @IBOutlet weak var textfieldMaxHumi: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    @IBOutlet weak var segmentTemp: UISegmentedControl!
    //@IBOutlet weak var segementLight: UISegmentedControl!
    @IBOutlet weak var segementHumid: UISegmentedControl!
    
    var prev_vc: String?
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 6){
            clickForExpanding[indexPath.row / 2] = !clickForExpanding[indexPath.row / 2]
            tableView.reloadData()
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let index = indexPath.row
        
        if index % 2 == 0 || index > 5{
            return 44.0
        }
        
        return cellHeightArray[((clickForExpanding[index / 2]) ? index / 2 + 1 : 0)]
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    //////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgPicker.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        tap.delegate = self
        profileImage.userInteractionEnabled = true
        profileImage.addGestureRecognizer(tap)
        
        segementHumid.selectedSegmentIndex = 1
        //segementLight.selectedSegmentIndex = 2
        
        prev_vc = dataStore.prev_vc
        print("prev_vc is \(prev_vc)")
        
        if(prev_vc == "main"){
            let coredata = coreData(entity: "User")
            index = dataStore.profile_index
            if(coredata.getCount() != 0){
                self.nameTxt.text = coredata.getDatasIndex(index!, key: "title") as? String
                self.memoTxt.text = coredata.getDatasIndex(index!, key: "memo") as? String
                self.serverTxt.text = String(coredata.getDatasIndex(index!, key: "numRotate") as! Int)
                
                self.textfieldMinTemp.text = String(coredata.getDatasIndex(index!, key: "minTemp") as! Int)
                self.textfieldMaxTemp.text = String(coredata.getDatasIndex(index!, key: "maxTemp") as! Int)
                self.textfieldMinHumi.text = String(coredata.getDatasIndex(index!, key: "minhum") as! Int)
                self.textfieldMaxHumi.text = String(coredata.getDatasIndex(index!, key: "maxhum") as! Int)
                self.profileImage.image = UIImage(data: coredata.getDatasIndex(index!, key: "image") as! NSData)
                
                let coredata = coreData(entity: "User")
                main_addr = coredata.getDatasIndex(index!, key: "server_addr1") as? String
                relay_addr = coredata.getDatasIndex(index!, key: "server_addr2") as? String
                
                print(String(coredata.getDatasIndex(index!, key: "numRotate") as? Int))
            }
            
        }else if(prev_vc == "add"){
            index = dataStore.numOfUser
        }else{
            //index = dataStore.now_index
        }
        
        
    }
    
    var schedulStr: String = ""
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let id: String = segue.identifier!
        if id == "timer"{
            //let navigationController = segue.destinationViewController as! UINavigationController
            //let VC = navigationController.topViewController as! schedulerViewController
            //VC.data = schedulStr
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
                parser += String(alarmData.getDatasIndex(startIndex + i, key: "hour") as! Int)
                parser += ":"
                parser += String(alarmData.getDatasIndex(startIndex + i, key: "minute") as! Int)
                parser += ":"
                parser += ((alarmData.getDatasIndex(startIndex + i, key: "isChecked") as! Bool) ? "true" : "false")
                parser += ";"
                
                print(parser)
            }
            
            dataStore.parserTime = parser
            print("-----end prepareFor segue")
        }
    }
    
    @IBAction func changeSegue(sender: UISegmentedControl) {
        if segementHumid.selectedSegmentIndex == 2 || segmentTemp.selectedSegmentIndex == 2{
            return
        }else{
            segementHumid.selectedSegmentIndex = (segmentTemp.selectedSegmentIndex == 0) ? 1 : 0
        }
    }
    
    @IBAction func changeSegeHumid(sender: UISegmentedControl) {
        if segementHumid.selectedSegmentIndex == 2 || segmentTemp.selectedSegmentIndex == 2{
            return
        }else{
            segmentTemp.selectedSegmentIndex = (segementHumid.selectedSegmentIndex == 0) ? 1 : 0
        }
    }
    
    @IBAction func clickCancel(sender: AnyObject) {
        dataStore.prev_vc = "else"
        dataStore.parserTime = ""
        //dataStore.index = -1
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    var tField: UITextField!, tField1: UITextField!
    
    @IBAction func clickSave(sender: AnyObject) {
        let credata = coreData(entity: "User")
        let dP = data_user(image: profileImage.image!, name: nameTxt.text!, memo: memoTxt.text!, server: main_addr!, server1: relay_addr!,//serverTxt.text!, server1:  serverTxt.text!,
            minTemp: Int(textfieldMinTemp.text! as String)!,
            maxTemp: Int(textfieldMaxTemp.text! as String)!,
            minHumid: Int(textfieldMinHumi.text! as String)!,
            maxHumid: Int(textfieldMaxHumi.text! as String)!,
            temperature_index: segmentTemp.selectedSegmentIndex,
            humidity_index: segementHumid.selectedSegmentIndex,
            numRotate: Int(serverTxt.text! as String)!) as data_user
        print("ininininininidex \(index)")
        //coredata save
        if(prev_vc == "add" || index == nil || credata.getCount() == 0){
            /////센서 콘피그도 넘기기
            let alert = UIAlertController(title: "", message: "본체와 릴레이의 주소를 차례대로 적어주세요", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addTextFieldWithConfigurationHandler({ (a) -> Void in
                a.placeholder = "본체"
                self.tField = a
            })
            alert.addTextFieldWithConfigurationHandler({ (b) -> Void in
                b.placeholder = "릴레이"
                self.tField1 = b
            })
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
                //self.http_reference?.postFedd()
                
                dP.server_addr1 = self.tField.text! as String
                dP.server_addr2 = self.tField1.text! as String
                
                self.main_addr = self.tField.text! as String
                self.relay_addr = self.tField1.text! as String
                
                
                self.firstConnectWifi()
                
                if self.check_alert{
                
                    if dataStore.parserTime != ""{
                        self.insertTime()
                    }
                
                    if(credata.getCount() == 0){
                        dataStore.profile_index = 0
                        NSNotificationCenter.defaultCenter().postNotificationName("asdf", object: self)
                    }
                
                    credata.insertData(dP)
                    self.abcd()
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .Destructive, handler: { (action: UIAlertAction!) in
                return
            }))
            
            presentViewController(alert, animated: true, completion: nil)
        }else{// if(prev_vc == "main"){
            //값 수정
            print(index)
            credata.setUserData(dP, index: index!)
            if dataStore.parserTime != ""{
                self.insertTime()
            }
            abcd()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        
        //self.dismissViewControllerAnimated(true, completion: nil)
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
    var text_wifi_id: UITextField!, text_wifi_password: UITextField!
    var wifi_id: String = "", wifi_password: String = ""
 
    
    func firstSendMessage(){
        let alert = UIAlertController(title: "사용하시는 WIFI를 입력해주세요.", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler { (a) -> Void in
            a.placeholder = "WIFI 이름"
            self.text_wifi_id = a
        }
        alert.addTextFieldWithConfigurationHandler { (b) -> Void in
            b.placeholder = "WIFI 비밀번호"
            self.text_wifi_password = b
        }
        alert.addAction(UIAlertAction(title: "입력완료", style: .Default, handler: {(action: UIAlertAction!) in
            self.wifi_id = self.text_wifi_id.text! as String
            self.wifi_password = self.text_wifi_password.text! as String
            print("\(self.wifi_id)   \(self.wifi_password)")
           
            
            
            
            print(self.fetchSSIDInfo())
        }))
        
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func abcd(){
        dropbox.setEnviromentSetting(relay_addr!,//serverTxt.text!,
            maxTemperature: Int(textfieldMaxTemp.text! as String)!,
            minTemperature: Int(textfieldMinTemp.text! as String)!,
            maxHumiidity:   Int(textfieldMaxHumi.text! as String)!,
            minHumidity:    Int(textfieldMinHumi.text! as String)!)
        
        dropbox.setRelaySetting(relay_addr!//serverTxt.text!
            , temp: segmentTemp.selectedSegmentIndex, humidity: segementHumid.selectedSegmentIndex)
        
        dataStore.parserTime = ""
        dataStore.prev_vc = "else"
    }
    
    func insertTime(){
        print("-----start insertTime")
        
        var foodJson: String = "["
        /////알람 다 삭제하고 하기
        let coredata = coreData(entity: "Alarm")
        let data = dataStore.parserTime
        //let index: Int? = dataStore.now_index
        let arrFull = data.componentsSeparatedByString(";")
        print(arrFull.count)
        for(var i = 0; i < arrFull.count - 1; i++){
            print(arrFull[i])
            let temp = arrFull[i].componentsSeparatedByString(":")
            print(temp)
            let hour: Int? = Int(temp[0])
            let min: Int? = Int(temp[1])
            let check: Bool = (temp[2] == "false" ? false : true)
            
            let rotate: Int = Int(serverTxt.text! as String)!
            foodJson += "{\"numRotate\": \(rotate), \"time\": \"\(String(hour! as Int)):\(String(min! as Int))\"}"
            if i != arrFull.count - 2{
                foodJson += ", "
            }
            
            coredata.insertTimer(hour!, min: min!, check: check, index: index!)
        }
        foodJson += "]"
        
        if arrFull.count > 2{
            dropbox.putSchedule(main_addr!, data: foodJson)
        }
        print("-----end insertTime")
    }
    
    func  preventOverlap(var first: Int, var second: Int, pivot: Int)-> (first: Int, second: Int){
        if(first == pivot){
            first = 6 / second / pivot
        }else if(second == pivot){
            second = 6 / pivot / first
        }
        return (first, second)
    }
    
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
        
        let pathExtention = (imageName as NSString).pathExtension
        //print(pathExtention)
        
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
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    /* did not change the profile image when user choose the cancel in the photo library */
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func fetchSSIDInfo() ->  String {
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
    }
}

