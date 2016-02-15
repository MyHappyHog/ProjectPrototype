//
//  schedulerViewController.swift
//  HHH
//
//  Created by Cho YoungHun on 2016. 1. 28..
//  Copyright © 2016년 hhh. All rights reserved.
//

import UIKit

class schedulerViewController: UITableViewController{
    var schedules = [SettingSchedulerCell]()//(isChecked: false, time_hour: 1, time_minute: 2)]
    var data: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //data parser 하기
        dataToTime(dataStore.parserTime)
    }
    
    func dataToTime(data: String){
        if data == ""{
            return
        }
        
        let arrFull = data.componentsSeparatedByString(";")
        //print(arrFull.count)
        for(var i = 0; i < arrFull.count - 1; i++){
            //print(arrFull[i])
            let temp = arrFull[i].componentsSeparatedByString(":")
            //print(temp)
            let hour: Int? = Int(temp[0])
            let min: Int? = Int(temp[1])
            let check: Bool = (temp[2] == "false" ? false : true)
            
            schedules.append(SettingSchedulerCell(isChecked: check, time_hour: hour!, time_minute: min!))
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedules.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("schedulerViewControllerCell", forIndexPath: indexPath) as! schedulerViewControllerCell
        let alarm = schedules[indexPath.row] as SettingSchedulerCell
        
        cell.list = alarm
        
        cell.onButtonTapped = {
            self.schedules[indexPath.row].isChecked = !self.schedules[indexPath.row].isChecked
        }
        
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let index = indexPath.row
        
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .Time) {
            (date) -> Void in
            //self.textField.text = "\(date)"
            //print(date)
            let format = NSDateFormatter()
            format.dateFormat = "HH:mm"
            let time = format.stringFromDate(date).componentsSeparatedByString(":")
            self.schedules[index].time_hour = Int(time[0])!
            self.schedules[index].time_minute = Int(time[1])!
            self.tableView.reloadData()
        }
    }
    
    var onDataAvailable: ((data: String) -> ())?
    
    @IBAction func clickCancel(sender: AnyObject) {
        var parser: String = ""
        
        for(var i = 0; i < schedules.count; i++){
            parser += String(schedules[i].time_hour! as Int)
            parser += ":"
            parser += String(schedules[i].time_minute! as Int)
            parser += ":"
            parser += ((schedules[i].isChecked) ? "true" : "false")
            parser += ";"
        }
        //여기서는 값 다시 돌려보내주기
        
        print("parser \(parser)")
        
        dataStore.parserTime = parser
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func clickAdd(sender: AnyObject) {
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .Time) {
            (date) -> Void in
            //self.textField.text = "\(date)"
            //print(date)
            let format = NSDateFormatter()
            format.dateFormat = "HH:mm"
            //print(format.stringFromDate(date))
            let time = format.stringFromDate(date).componentsSeparatedByString(":")
            self.schedules.append(SettingSchedulerCell(isChecked: false, time_hour: Int(time[0])!, time_minute: Int(time[1])!))
            self.tableView.reloadData()
        }
    }
}
