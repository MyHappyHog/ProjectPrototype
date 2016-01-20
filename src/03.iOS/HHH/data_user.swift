//
//  data_user.swift
//  HHH
//
//  Created by Cho YoungHun on 2016. 1. 18..
//  Copyright © 2016년 hhh. All rights reserved.
//

import Foundation

class data_user{
    var image: String?
    var name : String?
    var memo : String?
    var server_addr : String?
    var minTemp: Int?, maxTemp: Int?, minHumid: Int?, maxHumid: Int?
    
    
    var index : Int?
    
    init(name: String, memo: String, server: String, minTemp: Int, maxTemp: Int, minHumid: Int, maxHumid: Int){
        self.name = name
        self.memo = memo
        self.server_addr = server
        self.minTemp = minTemp
        self.maxTemp = maxTemp
        self.minHumid = minHumid
        self.maxHumid = maxHumid
    }
}