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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        print("in")
        let cell = tableView.dequeueReusableCellWithIdentifier("schedulerViewControllerCell", forIndexPath: indexPath) as! schedulerViewControllerCell
        let alarm = schedules[indexPath.row] as SettingSchedulerCell
        
        cell.list = alarm
        
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let index = indexPath.row
        
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .Time) {
            (date) -> Void in
            //self.textField.text = "\(date)"
            print(date)
            let format = NSDateFormatter()
            format.dateFormat = "HH:mm"
            let time = format.stringFromDate(date).componentsSeparatedByString(":")
            self.schedules[index].time_hour = Int(time[0])!
            self.schedules[index].time_minute = Int(time[1])!
            self.tableView.reloadData()
        }
    }
    
    
    
    @IBAction func clickCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func clickAdd(sender: AnyObject) {
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .Time) {
            (date) -> Void in
            //self.textField.text = "\(date)"
            print(date)
            let format = NSDateFormatter()
            format.dateFormat = "HH:mm"
            print(format.stringFromDate(date))
            let time = format.stringFromDate(date).componentsSeparatedByString(":")
            self.schedules.append(SettingSchedulerCell(isChecked: false, time_hour: Int(time[0])!, time_minute: Int(time[1])!))
            self.tableView.reloadData()
        }
    }
}
