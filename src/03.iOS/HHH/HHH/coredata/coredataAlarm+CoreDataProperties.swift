//
//  coredataAlarm+CoreDataProperties.swift
//  HHH
//
//  Created by Cho YoungHun on 2016. 1. 28..
//  Copyright © 2016년 hhh. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension coredataAlarm {

    @NSManaged var hour: NSNumber?
    @NSManaged var isChecked: NSNumber?
    @NSManaged var minute: NSNumber?
    @NSManaged var user_number: NSNumber?

}
