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
            let server_addr = value.valueForKey("server_addr1") as! String
            
            if(name == _name && memo == _memo && server_addr == _server_addr){
                return i as Int?
            }
        }
        
        return nil
    }
    
    /////user
    func insertData(data: data_user!){
        let userEntity = NSEntityDescription.entityForName("User", inManagedObjectContext: managedObjectContext!)
        
        let contact = credataUser(entity: userEntity!, insertIntoManagedObjectContext: managedObjectContext!)
        contact.title = data.name
        contact.memo = data.memo
        //contact.image = data.image
        contact.server_addr1 = data.server_addr1
        contact.server_addr2 = data.server_addr2
        contact.minTemp = data.minTemp
        contact.maxTemp = data.maxTemp
        contact.minhum = data.minHumid
        contact.maxhum = data.maxHumid
        contact.temperature_index = data.temperature_index
        contact.humidity_index = data.humidity_index
        contact.numRotate = data.numRotate
        
        (dataStore.extenstion == "JPG") ? (contact.image = UIImageJPEGRepresentation(data.image!, 1)) : (contact.image = UIImagePNGRepresentation(data.image!))
        
        do{
            try managedObjectContext?.save()
        }catch{
            print(error)
        }
        
    }
    
    func setUserData(data:data_user, index: Int){
        let value = objects![index] as! NSManagedObject
        
        value.setValue(data.name, forKey: "title")
        value.setValue(data.memo, forKey: "memo")
        value.setValue(data.server_addr1, forKey: "server_addr1")
        value.setValue(data.server_addr2, forKey: "server_addr2")
        value.setValue(data.minTemp, forKey: "minTemp")
        value.setValue(data.maxTemp, forKey: "maxTemp")
        value.setValue(data.minHumid, forKey: "minhum")
        value.setValue(data.maxHumid, forKey: "maxhum")
        value.setValue(data.temperature_index, forKey: "temperature_index")
        value.setValue(data.humidity_index, forKey: "humidity_index")
        value.setValue(data.numRotate, forKey: "numRotate")
        
        (dataStore.extenstion == "JPG") ? (value.setValue(UIImageJPEGRepresentation(data.image!, 1), forKey: "image")) : (value.setValue(UIImagePNGRepresentation(data.image!), forKey: "image"))
        
        do{
            try managedObjectContext?.save()
        }catch{
            print(error)
        }
    }
    
    func setProfileViewData(data:data_user, index: Int){
        let value = objects![index] as! NSManagedObject
        
        value.setValue(data.name, forKey: "title")
        value.setValue(data.memo, forKey: "memo")
        value.setValue(data.numRotate, forKey: "numRotate")
        value.setValue(data.server_addr1, forKey: "server_addr1")
        value.setValue(data.server_addr2, forKey: "server_addr2")
        //value.setValue(data.minTemp, forKey: "minTemp")
        //value.setValue(data.maxTemp, forKey: "maxTemp")
        //value.setValue(data.minHumid, forKey: "minhum")
        //value.setValue(data.maxHumid, forKey: "maxhum")
        
        (dataStore.extenstion == "JPG") ? (value.setValue(UIImageJPEGRepresentation(data.image!, 1), forKey: "image")) : (value.setValue(UIImagePNGRepresentation(data.image!), forKey: "image"))
        
        do{
            try managedObjectContext?.save()
        }catch{
            print(error)
        }
    }
    /////
    
    ///timer
    func insertTimer(time:String, num:Int, index: Int){
        let userEntity = NSEntityDescription.entityForName("Alarm", inManagedObjectContext: managedObjectContext!)
        
        let contact = coredataAlarm(entity: userEntity!, insertIntoManagedObjectContext: managedObjectContext!)
        contact.user_number = index
//        contact.hour = hour
//        contact.minute = min
//        contact.isChecked = check
        contact.num = num
        contact.time = time
        
        do{
            try managedObjectContext?.save()
        }catch{
            print(error)
        }
    }
    
    func getCountTimer(index: Int) -> Int{
        var count:Int = 0
        for(var i = 0; i < objects!.count; i++){
            let value = objects![i] as! NSManagedObject
            
            if(value.valueForKey("user_number") as! Int == index){
                count++
            }
        }
        return count
    }
    
    func getStartTimer(index: Int) -> Int{
        for(var i = 0; i < objects!.count; i++){
            let value = objects![i] as! NSManagedObject
            
            if(value.valueForKey("user_number") as! Int == index){
                return i
            }
        }
        
        return -1
    }
    
    func setTimer(index: Int, num: Int){
        let value = objects![index] as! NSManagedObject
        
        value.setValue(num, forKey: "user_number")
        
        do{
            try managedObjectContext?.save()
        }catch{
            print(error)
        }
    }
    
    ///
    
    ///// profile
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
    /////
    
    
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
    
    static func deleteItem(name: String, index: Int){
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext!
        let request = NSFetchRequest(entityName: name)
        request.returnsObjectsAsFaults = false
        
        do {
            let incidents = try context.executeFetchRequest(request)
            
            if incidents.count > 0 {
                context.deleteObject(incidents[index] as! NSManagedObject)
                /*for result: AnyObject in incidents{
                context.deleteObject(result as! NSManagedObject)
                print("NSManagedObject has been Deleted")
                }*/
                try context.save()
            }
        } catch {}
        
    }
}

