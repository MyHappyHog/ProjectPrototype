//
//  schedulerViewControllerCell.swift
//  HHH
//
//  Created by Cho YoungHun on 2016. 1. 28..
//  Copyright © 2016년 hhh. All rights reserved.
//

import UIKit

class schedulerViewControllerCell: UITableViewCell{
    var isChecked : Bool = false
    var time_hour : Int?
    var time_minute : Int?
    var no_check_img: UIImage = UIImage(named: "blank32-2")!
    var check_img: UIImage = UIImage(named: "check51-2")!
    
    var onButtonTapped : (() -> Void)? = nil
    
    /*init(hour: Int, min: Int){
        self.time_hour = hour
        self.time_minute = min
    }*/
    
    @IBOutlet weak var am_pm: UILabel!
    @IBOutlet weak var hour: UILabel!
    @IBOutlet weak var min: UILabel!
    @IBOutlet weak var check: UIImageView!
    @IBOutlet weak var checkBtn: UIButton!
    
    
    var list: SettingSchedulerCell!{
        didSet{
            time_hour = list.time_hour
            time_minute = list.time_minute
            isChecked = list.isChecked
            
            if time_hour > 11{
                am_pm.text = "PM"
                time_hour = time_hour! - 12
            }
            hour.text = String(time_hour! as Int)
            min.text = String(time_minute! as Int)
            
            check_condition()
        }
    }
    
    @IBAction func clickCheck(sender: AnyObject) {
        isChecked = !isChecked
        check_condition()
        if let onButtonTapped = self.onButtonTapped{
            onButtonTapped()
        }
    }
    func check_condition() {
        if isChecked{
            checkBtn.setImage(check_img, forState: .Normal)
            
        }else{
            checkBtn.setImage(no_check_img, forState: .Normal)
        }

    }
    
}