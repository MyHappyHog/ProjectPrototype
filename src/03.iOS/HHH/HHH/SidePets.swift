//
//  SidePets.swift
//  HHHPrototype
//
//  Created by Cho YoungHun on 2015. 11. 23..
//  Copyright © 2015년 Yoonseung Choi. All rights reserved.
//


//data struct for side list
import UIKit

struct SidePets{
    var image: String?
    var server_addr: String?
    
    var name: String?
    var memo: String?
    
    init(name: String?, memo: String?, image: String?, server_addr: String?){
        self.image = image
        self.server_addr = server_addr
        self.name = name
        self.memo = memo
    }
}

