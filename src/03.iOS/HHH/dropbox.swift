//
//  dropbox.swift
//  HHH
//
//  Created by Cho YoungHun on 2016. 2. 15..
//  Copyright © 2016년 hhh. All rights reserved.
//

import Foundation
import SwiftyDropbox


class dropbox{
    private static let SENSING_INFO = "sensingInfo.json"
    private static let ENVIROMENT_SETTING = "enviromentSetting.json"
    private static let RELAY_SETTING = "relaySetting.json"
    
    private static let FOOD = "foodSchedule.json"
    //
    //
    
    
    //
    static func getSensingData(address: String, completionHandler: (_temperature: Double?, _humidity: Double?)->Void){
        if let client = Dropbox.authorizedClient {
            var temperature : Double? = nil
            var humidity : Double? = nil
            
            let destination : (NSURL, NSHTTPURLResponse) -> NSURL = { temporaryURL, response in
                let fileManager = NSFileManager.defaultManager()
                let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
                // generate a unique name for this file in case we've seen it before
                let UUID = NSUUID().UUIDString
                let pathComponent = "\(UUID)-\(response.suggestedFilename!)"
                return directoryURL.URLByAppendingPathComponent(pathComponent)
            }
            
            let path = "/\(address)/\(SENSING_INFO)"
            print("path \(path)")
            
            client.files.download(path: path, destination: destination).response { response, error in
                if let (metadata, url) = response {
                    print("*** Download file ***")
                    let data = NSData(contentsOfURL: url)
                    
                    let context = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
                    print(context)
                    
                    //
                    do{
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                        
                        if let temp = json["temperature"] as? Double{
                            temperature = temp
                        }
                        if let humi = json["humidity"] as? Double{
                            humidity = humi
                        }
                        
                    }catch{
                        
                    }
                } else {
                    print(error!)
                }
                completionHandler(_temperature: temperature, _humidity: humidity)
            }
        }
    }
    
    static func setEnviromentSetting(address: String, maxTemperature: Int, minTemperature: Int, maxHumiidity: Int, minHumidity: Int){
        if let client = Dropbox.authorizedClient {
            
            let destination : (NSURL, NSHTTPURLResponse) -> NSURL = { temporaryURL, response in
                let fileManager = NSFileManager.defaultManager()
                let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
                // generate a unique name for this file in case we've seen it before
                let UUID = NSUUID().UUIDString
                let pathComponent = "\(UUID)-\(response.suggestedFilename!)"
                return directoryURL.URLByAppendingPathComponent(pathComponent)
            }
            
            let path = "/\(address)/\(ENVIROMENT_SETTING)"
            
            let string = "{\"tempeature\": [\(maxTemperature), \(minTemperature)], \"humidity\": [\(maxHumiidity), \(minHumidity)]}"
            print(string)
            
            let fileData = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            
            
            client.files.download(path: path, destination: destination).response { response, error in
                if let (metadata, url) = response {
                    print("*** Download file ***")
                    let data = NSData(contentsOfURL: url)
                    
                    let context = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
                    print("sdfsdf \(context)")
                    
                    print(metadata.rev)
                    
                    client.files.upload(path: path, mode: Files.WriteMode.Update(metadata.rev), autorename: false, clientModified: nil, mute: false, body: fileData!)
                } else {
                    print(error!)
                    client.files.upload(path: path, body: fileData!)
                }

            }
        }
    }
    
    static func putSchedule(address:String, data: String){
        if let client = Dropbox.authorizedClient{
            let destination : (NSURL, NSHTTPURLResponse) -> NSURL = { temporaryURL, response in
                let fileManager = NSFileManager.defaultManager()
                let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
                // generate a unique name for this file in case we've seen it before
                let UUID = NSUUID().UUIDString
                let pathComponent = "\(UUID)-\(response.suggestedFilename!)"
                return directoryURL.URLByAppendingPathComponent(pathComponent)
            }
            let path = "/\(address)/\(FOOD)"
            print("path \(path)")

            client.files.download(path: path, destination: destination).response { response, error in
                let fileData = data.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                
                if let (metadata, url) = response {
                    print("*** Download file ***")
                    let data = NSData(contentsOfURL: url)
                    
                    let context = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
                    print("sdfsdf \(context)")
                    
                    print(metadata.rev)

                    client.files.upload(path: path, mode: Files.WriteMode.Update(metadata.rev), autorename: false, clientModified: nil, mute: false, body: fileData!)
                } else {
                    print(error!)
                    
                    client.files.upload(path: path, body: fileData!)
                }
                
            }
        }
    }
    
    static func putTheFeed(address: String, rotate: Int){
        if let client = Dropbox.authorizedClient {
            
            let destination : (NSURL, NSHTTPURLResponse) -> NSURL = { temporaryURL, response in
                let fileManager = NSFileManager.defaultManager()
                let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
                // generate a unique name for this file in case we've seen it before
                let UUID = NSUUID().UUIDString
                let pathComponent = "\(UUID)-\(response.suggestedFilename!)"
                return directoryURL.URLByAppendingPathComponent(pathComponent)
            }
            
            let path = "/\(address)/\(FOOD)"
            print("path \(path)")
            let string = "{\"numRotate\": \(rotate), \"time\": \"now\"}"
//            print(string)
            
            client.files.download(path: path, destination: destination).response { response, error in
                if let (metadata, url) = response {
                    print("*** Download file ***")
                    let data = NSData(contentsOfURL: url)
                    
                    let context = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
                    print("sdfsdf \(context)")
                    
                    print(metadata.rev)
                    
                    var _temp = "["
                    do{
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                        
                        for(var i = 0; i < json.count; i++){
                            if json[i]["time"] as! String == "now"{
                                continue
                            }
                            
                            _temp += "{\"numRotate\": \(json[i]["numRotate"] as! Int), \"time\": \"\(json[i]["time"] as! String)\"}, "
                            if i != json.count - 1{
                                _temp += ","
                            }
                        }
                    }catch{
                        
                    }
                    //let temp = "\(NSString(data: data!, encoding: NSUTF8StringEncoding) as! String), \(string)"
                    _temp += "\(string)]"
                    print(_temp)
                    let _fileData = _temp.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                    
                    client.files.upload(path: path, mode: Files.WriteMode.Update(metadata.rev), autorename: false, clientModified: nil, mute: false, body: _fileData!)
                } else {
                    print(error!)
                    
                    let fileData = "[\(string)]".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                    client.files.upload(path: path, body: fileData!)
                }
                
            }
        }

    }
    
    static func setRelaySetting(address: String, temp: Int, humidity: Int){
        if let client = Dropbox.authorizedClient {
            
            let destination : (NSURL, NSHTTPURLResponse) -> NSURL = { temporaryURL, response in
                let fileManager = NSFileManager.defaultManager()
                let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
                // generate a unique name for this file in case we've seen it before
                let UUID = NSUUID().UUIDString
                let pathComponent = "\(UUID)-\(response.suggestedFilename!)"
                return directoryURL.URLByAppendingPathComponent(pathComponent)
            }
            
            let path = "/\(address)/\(RELAY_SETTING)"
            
            let string = "{\"tempeature\": \(temp), \"humidity\": \(humidity)}"
            print(string)
            
            let fileData = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            
            
            client.files.download(path: path, destination: destination).response { response, error in
                if let (metadata, url) = response {
                    print("*** Download file ***")
                    let data = NSData(contentsOfURL: url)
                    
                    let context = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
                    print("sdfsdf \(context)")
                    
                    print(metadata.rev)
                    
                    client.files.upload(path: path, mode: Files.WriteMode.Update(metadata.rev), autorename: false, clientModified: nil, mute: false, body: fileData!)
                } else {
                    print(error!)
                    client.files.upload(path: path, body: fileData!)
                }
                
            }
        }

    }
}