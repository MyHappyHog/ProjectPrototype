//
//  credataUser+CoreDataProperties.swift
//  
//
//  Created by Cho YoungHun on 2016. 2. 20..
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension credataUser {

    @NSManaged var humidity_index: NSNumber?
    @NSManaged var image: NSData?
    @NSManaged var maxhum: NSNumber?
    @NSManaged var maxTemp: NSNumber?
    @NSManaged var memo: String?
    @NSManaged var minhum: NSNumber?
    @NSManaged var minTemp: NSNumber?
    @NSManaged var server_addr1: String?
    @NSManaged var temperature_index: NSNumber?
    @NSManaged var title: String?
    @NSManaged var user_number: NSNumber?
    @NSManaged var server_addr2: String?
    @NSManaged var numRotate: NSNumber?
    @NSManaged var alram: coredataAlarm?

}
