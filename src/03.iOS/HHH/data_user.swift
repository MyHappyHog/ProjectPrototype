//
//  data_user.swift
//  HHH
//
//  Created by Cho YoungHun on 2016. 1. 18..
//  Copyright © 2016년 hhh. All rights reserved.
//

import Foundation

class data_user{
    var image: UIImage?
    var name : String?
    var memo : String?
    var server_addr1 : String?
    var server_addr2 : String?
    var numRotate : Int?
    var minTemp: Int?, maxTemp: Int?, minHumid: Int?, maxHumid: Int?
    var temperature_index: Int?, humidity_index: Int?
    
    
    var index : Int?
    
    init(image: UIImage, name: String, memo: String, server: String, server1: String, minTemp: Int, maxTemp: Int, minHumid: Int, maxHumid: Int,
        temperature_index: Int, humidity_index: Int, numRotate: Int){
        self.image = image
        self.name = name
        self.memo = memo
        self.server_addr1 = server
        self.server_addr2 = server1
        self.minTemp = minTemp
        self.maxTemp = maxTemp
        self.minHumid = minHumid
        self.maxHumid = maxHumid
        self.temperature_index = temperature_index
        self.humidity_index = humidity_index
        self.numRotate = numRotate
    }
}