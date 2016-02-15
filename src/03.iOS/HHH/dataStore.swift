//
//  dataStore.swift
//  HHH
//
//  Created by Cho YoungHun on 2016. 1. 9..
//  Copyright © 2016년 hhh. All rights reserved.
//


//datastruct for once user
import Foundation

class dataStore{
    //all update val
    static var isClicked : Bool? = false
    
    //detail update val
    static var isClickedAdd : Bool? = false
    static var isClickedShare : Bool? = false
    static var isClickedSetting : Bool? = false
    
    //if changed data
    static var index : Int?
    
    //type image
    static var extenstion: String = "JPG"
    
    static var prev_vc: String?
    
    //shcudler
    static var parserTime: String = ""
    static var prev_sch: String = ""
    
    static var now_index: Int?
    
    
    static var profile_index: Int?
    static var timer_index: Int?
    
    static var numOfUser: Int?
    
    static var feeding_index: Int?
}

