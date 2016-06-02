//
//  feedingViewController.swift
//  HHH
//
//  Created by Cho YoungHun on 2016. 4. 21..
//  Copyright © 2016년 hhh. All rights reserved.
//

import UIKit

class feedingViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource  {
    //for list cell
    var time_list = [feedingCellClass]()
    
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var cycleTextField: UITextField!
    
    @IBOutlet weak var tebleView: UITableView!
    
    @IBAction func timeTextFieldEditing(sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Time
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: "datePickerValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
    }
    @IBAction func clickCancel(sender: AnyObject) {
        var parser: String = ""
        
        for(var i = 0; i < time_list.count; i++){
            parser += time_list[i].time_str!
            parser += "@"
            parser += String(time_list[i].time_num! as Int)
            parser += ";"
        }
        //여기서는 값 다시 돌려보내주기
        
        print("parser \(parser)")
        if(parser != ""){
            print(parser.endIndex)
            //print(parser[parser.endIndex])
//            parser.removeAtIndex(parser.endIndex - 1)
            parser.removeAtIndex(parser.endIndex.predecessor())
        }
        dataStore.parserTime = parser
        
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    @IBAction func clickAdd(sender: AnyObject) {
        let str = timeTextField.text! as String
        let num = Int(cycleTextField.text! as String)
        
        if str == "" || num == nil{
            return;
        }
        self.time_list.append(feedingCellClass(time_str: str, time_num: num!))
        
        timeTextField.text = ""
        cycleTextField.text = ""
        
        tebleView.reloadData()
    }
    
    
    func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        let theTimeFormat = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = theTimeFormat
        
        timeTextField.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProFileViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //set number pad
        cycleTextField.delegate = self
        cycleTextField.keyboardType = .NumberPad
        
        tebleView.delegate = self
        tebleView.dataSource = self
        
        dataToTime(dataStore.parserTime)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return time_list.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "feedingCell"
        
        var cell: feedingTableViewCell! = tableView.dequeueReusableCellWithIdentifier(identifier) as? feedingTableViewCell
        
        if cell == nil {
            tableView.registerNib(UINib(nibName: "feedingCellClass", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? feedingTableViewCell
        }
        cell.list = time_list[indexPath.row] as feedingCellClass
        
        return cell
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .Normal, title: "Delete") { action, index in
            self.time_list.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
        delete.backgroundColor = UIColor.redColor()
        
        return [delete]
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    func dataToTime(data: String){
        if data == ""{
            return
        }
        print("-----start data to time------")
        let arrFull = data.componentsSeparatedByString(";")
        //print(arrFull.count)
        for(var i = 0; i < arrFull.count; i++){
            print(arrFull[i])
            if arrFull[i] == ""{
                continue
            }
            let temp = arrFull[i].componentsSeparatedByString("@")
            //print(temp)
            let time:String = temp[0] as String
            let num: Int = Int(temp[1] as String)!
            
            time_list.append(feedingCellClass(time_str: time, time_num: num))
            
        }
        print("-----end data to time------")
    }
}
