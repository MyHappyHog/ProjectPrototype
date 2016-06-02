//
//  coredataAlarm+CoreDataProperties.swift
//  
//
//  Created by Cho YoungHun on 2016. 4. 22..
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension coredataAlarm {

    @NSManaged var num: NSNumber?
    @NSManaged var user_number: NSNumber?
    @NSManaged var time: String?

}
