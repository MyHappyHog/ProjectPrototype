//
//  coredataprofileProfile+CoreDataProperties.swift
//  HHH
//
//  Created by Cho YoungHun on 2016. 1. 2..
//  Copyright © 2016년 hhh. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension coredataprofileProfile {

    @NSManaged var image: String?
    @NSManaged var memo: String?
    @NSManaged var server_addr: String?
    @NSManaged var name: String?

}
