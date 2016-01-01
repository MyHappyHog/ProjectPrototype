//
//  SettingSchedulerCell.swift
//  HHH
//
//  Created by Cho YoungHun on 2015. 12. 31..
//  Copyright © 2015년 hhh. All rights reserved.
//

import UIKit

struct SettingSchedulerCell {
    var isChecked : Bool = false
    var time_hour : Int?
    var time_minute : Int?
    var isChecked_week  = [ false, false, false, false, false, false, false]
    
    init(isChecked: Bool, time_hour: Int, time_minute: Int){
        self.isChecked = isChecked
        self.time_hour = time_hour
        self.time_minute = time_minute
    }

}
