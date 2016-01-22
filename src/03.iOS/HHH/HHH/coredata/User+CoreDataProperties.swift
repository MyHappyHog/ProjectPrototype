//
//  User+CoreDataProperties.swift
//  HHH
//
//  Created by Cho YoungHun on 2016. 1. 22..
//  Copyright © 2016년 hhh. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var image: NSData?
    @NSManaged var maxhum: NSNumber?
    @NSManaged var maxTemp: NSNumber?
    @NSManaged var memo: String?
    @NSManaged var minhum: NSNumber?
    @NSManaged var minTemp: NSNumber?
    @NSManaged var server_addr: String?
    @NSManaged var title: String?
    @NSManaged var user_number: NSNumber?

}
