//
//  feedingTableViewCell.swift
//  HHH
//
//  Created by Cho YoungHun on 2016. 4. 21..
//  Copyright © 2016년 hhh. All rights reserved.
//

import UIKit

class feedingCellClass{
    var time_num: Int?
    var time_hour : Int?
    var time_minute : Int?
    var time_str: String?
    
    /*init(time_num: Int, time_hour: Int, time_minute: Int){
        self.time_num = time_num
        self.time_hour = time_hour
        self.time_minute = time_minute
    }*/
    init(time_str: String, time_num: Int){
        self.time_str = time_str
        self.time_num = time_num
    }

}

class feedingTableViewCell: UITableViewCell {
    var time_hour : Int?
    var time_minute : Int?
    var time_num: Int?
    var time_str: String?
    
    @IBOutlet weak var full_text: UILabel!
    
    var list:feedingCellClass!{
        didSet{
            //time_hour = list.time_hour
            //time_minute = list.time_minute
            time_num = list.time_num
            time_str = list.time_str
            
            var text = String(time_num! as Int)
            text += " cycle : "
            text += time_str! as String
            
            /*if time_hour > 11{
                text += "(PM)"
                time_hour = time_hour! - 12
            }else{
                text += "(AM)"
            }
            
            text += String(time_hour! as Int)
            text += String(time_minute! as Int)*/
            
            full_text.text = text
        }
    }
}
