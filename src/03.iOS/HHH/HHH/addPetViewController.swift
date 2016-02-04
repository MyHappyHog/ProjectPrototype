//
//  SettingViewController.swift
//  HHHPrototype
//
//  Created by Yoonseung Choi on 2015. 10. 14..
//  Copyright © 2015년 Yoonseung Choi. All rights reserved.
//

import UIKit


class addPetViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    //var isExpanding : Bool = false
    var clickForExpanding = [false, false, false, false]
    var cellHeightArray : [CGFloat] = [0.0, 400.0, 200.0, 220.0]
    var now_expanding : Int = -1
    var num_expanded : Int = 0
    
    let imgPicker = UIImagePickerController()
    var image :UIImage = UIImage(named: "sampleant")!
    
    
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
    @IBOutlet weak var segementLight: UISegmentedControl!
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
    override func viewDidAppear(animated: Bool) {

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgPicker.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        tap.delegate = self
        profileImage.userInteractionEnabled = true
        profileImage.addGestureRecognizer(tap)
        
        segementHumid.selectedSegmentIndex = 1
        segementLight.selectedSegmentIndex = 2
        
        prev_vc = dataStore.prev_vc
        print(prev_vc)
        
        if(prev_vc == "main"){
            let coredata = coreData(entity: "User")
            if(coredata.getCount() == 0){
                return
            }else{//
                let index = dataStore.index!
                self.nameTxt.text = coredata.getDatasIndex(index, key: "title") as? String
                self.memoTxt.text = coredata.getDatasIndex(index, key: "memo") as? String
                self.serverTxt.text = coredata.getDatasIndex(index, key: "server_addr") as? String
                
                self.textfieldMinTemp.text = String(coredata.getDatasIndex(index, key: "minTemp") as! Int)
                self.textfieldMaxTemp.text = String(coredata.getDatasIndex(index, key: "maxTemp") as! Int)
                self.textfieldMinHumi.text = String(coredata.getDatasIndex(index, key: "minhum") as! Int)
                self.textfieldMaxHumi.text = String(coredata.getDatasIndex(index, key: "maxhum") as! Int)
                self.profileImage.image = UIImage(data: coredata.getDatasIndex(index, key: "image") as! NSData)
            }

        }else if(prev_vc == "setting"){
            
        }
        
    }
    
    var schedulStr: String = ""
 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  
        let id: String = segue.identifier!
        if id == "timer"{
            //let navigationController = segue.destinationViewController as! UINavigationController
            //let VC = navigationController.topViewController as! schedulerViewController
            //VC.data = schedulStr
            
            let alarmData = coreData(entity: "Alarm")
            
            
            var parser: String = ""
            let index = dataStore.now_index
            
            for(var i = 0; i < alarmData.getCount(); i++){
                parser += String(alarmData.getDatasIndex(index!, key: "hour") as! Int)
                parser += ":"
                parser += String(alarmData.getDatasIndex(index!, key: "minute") as! Int)
                parser += ":"
                parser += ((alarmData.getDatasIndex(index!, key: "isChecked") as! Bool) ? "true" : "false")
                parser += ";"
            }
            
            dataStore.parserTime = parser
        }
    }
    
    @IBAction func changeSegue(sender: UISegmentedControl) {
        let num = preventOverlap(segementHumid.selectedSegmentIndex + 1, second: segementLight.selectedSegmentIndex + 1,
            pivot: segmentTemp.selectedSegmentIndex + 1)
        segementHumid.selectedSegmentIndex = num.first - 1
        segementLight.selectedSegmentIndex = num.second - 1
    }
    
    @IBAction func changeSegeHumid(sender: UISegmentedControl) {
        let num = preventOverlap(segmentTemp.selectedSegmentIndex + 1, second: segementLight.selectedSegmentIndex + 1,
            pivot: segementHumid.selectedSegmentIndex + 1)
        segmentTemp.selectedSegmentIndex = num.first - 1
        segementLight.selectedSegmentIndex = num.second - 1
    }
    
    @IBAction func changeSegeLight(sender: UISegmentedControl) {
        /*let indexTemp = segmentTemp.selectedSegmentIndex + 1
        let indexHumid = segementHumid.selectedSegmentIndex + 1
        let indexLight = segementLight.selectedSegmentIndex + 1
        if(segmentTemp.selectedSegmentIndex == indexLight - 1){
            segmentTemp.selectedSegmentIndex = 6 / indexHumid / indexLight - 1
        }else if(segementHumid.selectedSegmentIndex == indexLight - 1){
            segementHumid.selectedSegmentIndex = 6 / indexLight / indexTemp - 1
        }*/
        let num = preventOverlap(segmentTemp.selectedSegmentIndex + 1, second: segementHumid.selectedSegmentIndex + 1,
            pivot: segementLight.selectedSegmentIndex + 1)
        segmentTemp.selectedSegmentIndex = num.first - 1
        segementHumid.selectedSegmentIndex = num.second - 1
    }
    
    @IBAction func clickCancel(sender: AnyObject) {
        dataStore.prev_vc = "else"
        dataStore.parserTime = ""
        //dataStore.index = -1
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func clickSave(sender: AnyObject) {
        //coredata save
        if(prev_vc == "add"){
            /////센서 콘피그도 넘기기
            let credata = coreData(entity: "User")
            let dP = data_user(image: image, name: nameTxt.text!, memo: memoTxt.text!, server: serverTxt.text!,
                minTemp: Int(textfieldMinTemp.text! as String)!,
                maxTemp: Int(textfieldMaxTemp.text! as String)!,
                minHumid: Int(textfieldMinHumi.text! as String)!,
                maxHumid: Int(textfieldMaxHumi.text! as String)!) as data_user
            credata.insertData(dP)
            
            let http_reference = HttpReference(serverTxt.text! as String)
            http_reference.postSensorData(Int(textfieldMaxTemp.text! as String)!
                , minTemprature: Int(textfieldMinTemp.text! as String)!,
                maxHumidity: Int(textfieldMaxHumi.text! as String)!,
                minHumidity: Int(textfieldMinHumi.text! as String)!)
            
            if dataStore.parserTime != ""{
                insertTime()
            }
            if(credata.getCount() == 0){
                dataStore.index = 0
                NSNotificationCenter.defaultCenter().postNotificationName("asdf", object: self)
            }
        }else{// if(prev_vc == "main"){
            //값 수정
        }

        
        dataStore.prev_vc = "else"
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func insertTime(){
        let coredata = coreData(entity: "Alarm")
        let data = dataStore.parserTime
        let index: Int? = dataStore.now_index
        let arrFull = data.componentsSeparatedByString(";")
        print(arrFull.count)
        for(var i = 0; i < arrFull.count - 1; i++){
            print(arrFull[i])
            let temp = arrFull[i].componentsSeparatedByString(":")
            print(temp)
            let hour: Int? = Int(temp[0])
            let min: Int? = Int(temp[1])
            let check: Bool = (temp[2] == "false" ? false : true)
            
            coredata.insertTimer(hour!, min: min!, check: check, index: index!)
        }
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
        
        self.image = newImage
        self.profileImage.image = self.image
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    /* did not change the profile image when user choose the cancel in the photo library */
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
