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
        
        let contact = User(entity: userEntity!, insertIntoManagedObjectContext: managedObjectContext!)
        contact.title = data.name
        contact.memo = data.memo
        contact.image = "samplehog"
        contact.server_addr = data.server_addr
        
        do{
            try managedObjectContext?.save()
        }catch{
            print(error)
        }

    }
}

