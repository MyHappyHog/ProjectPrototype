//
//  Profile+CoreDataProperties.swift
//  HHHPrototype
//
//  Created by Cho YoungHun on 2015. 11. 24..
//  Copyright © 2015년 Yoonseung Choi. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Profile {

    @NSManaged var image: String?
    @NSManaged var memo: String?
    @NSManaged var name: String?

}
