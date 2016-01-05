//
//  coreData.swift
//  HHH
//
//  Created by Cho YoungHun on 2016. 1. 5..
//  Copyright © 2016년 hhh. All rights reserved.
//

import Foundation
import CoreData

class coreData{
    let managedObjectContext:NSManagedObjectContext?
    var entity: String?
    
    //get
    let entityDescription: NSEntityDescription?
    let request = NSFetchRequest()
    var objects: [AnyObject]?
    
    
    //insert
    
    init(entity: String){
        managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        self.entity = entity
        entityDescription = NSEntityDescription.entityForName(self.entity!, inManagedObjectContext: managedObjectContext!)
        request.entity = entityDescription
        setObjects()
    }
    
    private func setObjects(){
        do{
            self.objects = try managedObjectContext!.executeFetchRequest(request)
        }catch{
            print(error)
        }
    }
    
    func getDatas() -> AnyObject?{
        if(entity != nil){
            let entityDescription = NSEntityDescription.entityForName(entity!, inManagedObjectContext: managedObjectContext!)
            
            let request = NSFetchRequest()
            request.entity = entityDescription
            
            do{
                return try managedObjectContext!.executeFetchRequest(request)
            }catch{
                print(error)
            }
        }
        else{
            return nil
        }
        return nil
    }
    
    func getCount() -> Int?{
        return objects!.count
    }
    
    func getDatasIndex(index: Int, key: String) -> AnyObject?{
        let value = objects![index] as! NSManagedObject
        
        return value.valueForKey(key)
    }
}
