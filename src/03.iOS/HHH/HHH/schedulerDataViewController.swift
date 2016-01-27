//
//  schedulerDataViewController.swift
//  HHH
//
//  Created by Cho YoungHun on 2016. 1. 28..
//  Copyright © 2016년 hhh. All rights reserved.
//

import UIKit
import QuartzCore
import Foundation

class schedulerDataViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .Time) {
            (date) -> Void in
            //self.textField.text = "\(date)"
        }
    }
    @IBAction func clickCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
