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
    
    func getsearchIndex(_name: String!, _memo: String!, _server_addr: String!) -> Int?{
        print("in serch index")
        print(_name)
        print(_memo)
        print(_server_addr)
        for(var i = 0; i < objects!.count; i++){
            let value = objects![i] as! NSManagedObject
            
            let name = value.valueForKey("title") as! String
            let memo = value.valueForKey("memo") as! String
            let server_addr = value.valueForKey("server_addr") as! String
            
            if(name == _name && memo == _memo && server_addr == _server_addr){
                return i as Int?
            }
        }
        
        return nil
    }
    
    func insertData(data: data_user!){
        let userEntity = NSEntityDescription.entityForName("User", inManagedObjectContext: managedObjectContext!)
        
        let contact = credataUser(entity: userEntity!, insertIntoManagedObjectContext: managedObjectContext!)
        contact.title = data.name
        contact.memo = data.memo
        //contact.image = "samplehog"
        contact.server_addr = data.server_addr
        contact.minTemp = data.minTemp
        contact.maxTemp = data.maxTemp
        contact.minhum = data.minHumid
        contact.maxhum = data.maxHumid
        
        (dataStore.extenstion == "JPG") ? (contact.image = UIImageJPEGRepresentation(data.image!, 1)) : (contact.image = UIImagePNGRepresentation(data.image!))
        
        do{
            try managedObjectContext?.save()
        }catch{
            print(error)
        }

    }

    func insertTimer(hour: Int, min: Int, check: Bool, index: Int){
        let userEntity = NSEntityDescription.entityForName("Alarm", inManagedObjectContext: managedObjectContext!)
        
        let contact = coredataAlarm(entity: userEntity!, insertIntoManagedObjectContext: managedObjectContext!)
        contact.user_number = index
        contact.hour = hour
        contact.minute = min
        contact.isChecked = check
        
        do{
            try managedObjectContext?.save()
        }catch{
            print(error)
        }
    }
    
    
    //for debuging
    static func deleteAllItem(name: String){
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext!
        let request = NSFetchRequest(entityName: name)
        request.returnsObjectsAsFaults = false
        
        do {
            let incidents = try context.executeFetchRequest(request)
            
            if incidents.count > 0 {
                
                for result: AnyObject in incidents{
                    context.deleteObject(result as! NSManagedObject)
                    print("NSManagedObject has been Deleted")
                }
                try context.save()
            }
        } catch {}
    }
    
    func insertProfile(index: Int){
        let userEntity = NSEntityDescription.entityForName("Profile", inManagedObjectContext: managedObjectContext!)
        
        let contact = coredataProfile(entity: userEntity!, insertIntoManagedObjectContext: managedObjectContext!)
        contact.user_index = index
        
        do{
            try managedObjectContext?.save()
        }catch{
            print(error)
        }
    }
    
    func setProfile(index: Int){
        let value = objects![0] as! NSManagedObject
        
        value.setValue(index, forKey: "user_index")
        
        do{
            try managedObjectContext?.save()
        }catch{
            print(error)
        }
    }
}

