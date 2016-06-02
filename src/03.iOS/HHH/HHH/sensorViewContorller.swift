//
//  sensorViewContorller.swift
//  HHH
//
//  Created by Cho YoungHun on 2016. 4. 18..
//  Copyright © 2016년 hhh. All rights reserved.
//

import UIKit

class sensorViewContorller: UIViewController, UITextFieldDelegate {
    /*
    *
    *   view variable
    *
    */
    @IBOutlet weak var minTemp: UITextField!
    @IBOutlet weak var maxTemp: UITextField!
    @IBOutlet weak var temp_first_btn: UIButton!
    @IBOutlet weak var temp_second_btn: UIButton!
    @IBOutlet weak var temp_third_btn: UIButton!
    /////////
    @IBOutlet weak var minHumid: UITextField!
    @IBOutlet weak var maxHumid: UITextField!
    @IBOutlet weak var humid_first_btn: UIButton!
    @IBOutlet weak var humid_second_btn: UIButton!
    @IBOutlet weak var humid_third_btn: UIButton!
    
    /*
    *
    *   another variable
    *
    */
    var temp_now_position: Int = 0
    var humid_now_position: Int = 1
    
    var orange: UIColor = UIColor(red: 223/255, green: 121/255, blue: 45/255, alpha: 1)
    var white: UIColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    var temp_arr:[UIButton] = []
    var humid_arr: [UIButton] = []
    
    /*
    *
    *   click event func
    *
    */
    @IBAction func clickCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func clickSave(sender: AnyObject) {
        let user = dataStore.temp_user
        
        dataStore.temp_user!.minTemp = Int(minTemp.text! as String)! as Int
        dataStore.temp_user!.maxTemp = Int(maxTemp.text! as String)! as Int
        dataStore.temp_user!.temperature_index = temp_now_position
        
        dataStore.temp_user!.minHumid = Int(minHumid.text! as String)! as Int
        dataStore.temp_user!.maxHumid = Int(maxHumid.text! as String)! as Int
        dataStore.temp_user!.humidity_index = humid_now_position
        
        //dataStore.temp_user = user
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    @IBAction func click_temp_first(sender: AnyObject) {
        setWhiteTempBtn(0)
        check_same_index(0)
    }
    @IBAction func click_temp_second(sender: AnyObject) {
        setWhiteTempBtn(1)
        check_same_index(0)
    }
    @IBAction func click_temp_third(sender: AnyObject) {
        setWhiteTempBtn(2)
        check_same_index(0)
    }
    
    
    @IBAction func click_humid_first(sender: AnyObject) {
        setWhiteHumidBtn(0)
        check_same_index(1)
    }
    @IBAction func click_humid_second(sender: AnyObject) {
        setWhiteHumidBtn(1)
        check_same_index(1)
    }
    @IBAction func click_humid_third(sender: AnyObject) {
        setWhiteHumidBtn(2)
        check_same_index(1)
    }
    
    /*
    *
    *   make func
    *
    */
    func setWhiteTempBtn(set: Int){
        temp_arr[temp_now_position].backgroundColor = white
        temp_now_position = set
        temp_arr[temp_now_position].backgroundColor = orange
    }
    func setWhiteHumidBtn(set: Int){
        humid_arr[humid_now_position].backgroundColor = white
        humid_now_position = set
        humid_arr[humid_now_position].backgroundColor = orange
    }
    func setNumberPad(obj: UITextField){
        obj.delegate = self
        obj.keyboardType = .NumberPad
    }
    func check_same_index(type: Int){
        if(temp_now_position == 2 || humid_now_position == 2){
            return
        }
        if(temp_now_position == humid_now_position){
            if type == 0{ //temp
                //humid_now_position = (temp_now_position == 1) ? 0 : 1
                setWhiteHumidBtn((temp_now_position == 1) ? 0 : 1)
            }else{ //humidity
                //temp_now_position = (humid_now_position == 1) ? 0 : 1
                setWhiteTempBtn((humid_now_position == 1) ? 0 : 1)
            }
        }
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProFileViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //set segement
        temp_arr.append(temp_first_btn)
        temp_arr.append(temp_second_btn)
        temp_arr.append(temp_third_btn)
        
        humid_arr.append(humid_first_btn)
        humid_arr.append(humid_second_btn)
        humid_arr.append(humid_third_btn)
        
        if(dataStore.prev_vc == "main"){
            let coredata = coreData(entity: "User")
            let index = dataStore.profile_index
            minTemp.text = String(coredata.getDatasIndex(index!, key: "minTemp") as! Int)
            maxTemp.text = String(coredata.getDatasIndex(index!, key: "maxTemp") as! Int)
            
            minHumid.text = String(coredata.getDatasIndex(index!, key: "minhum") as! Int)
            maxHumid.text = String(coredata.getDatasIndex(index!, key: "maxhum") as! Int)
            
            temp_now_position = (coredata.getDatasIndex(index!, key: "temperature_index") as? Int)!
            humid_now_position = (coredata.getDatasIndex(index!, key: "humidity_index") as? Int)!
        }else{
            minTemp.text = String((dataStore.temp_user?.minTemp)! as Int)
            maxTemp.text = String((dataStore.temp_user?.maxTemp)! as Int)
            
            minHumid.text = String((dataStore.temp_user?.minHumid)! as Int)
            maxHumid.text = String((dataStore.temp_user?.maxHumid)! as Int)
            
            temp_now_position = (dataStore.temp_user?.temperature_index)!
            humid_now_position = (dataStore.temp_user?.humidity_index)!
        }
        
        setWhiteTempBtn(temp_now_position)
        setWhiteHumidBtn(humid_now_position)
        
        setNumberPad(minTemp)
        setNumberPad(maxTemp)
        setNumberPad(minHumid)
        setNumberPad(maxHumid)
    }
    
    /*func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = NSCharacterSet(charactersInString: "0123456789").invertedSet
        return string.rangeOfCharacterFromSet(invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
    }*/
}
