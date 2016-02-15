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
    private static let SENSING_INFO = "SensingInfo.json"
    private static let ENVIROMENT_SETTING = "EnviromentSetting.json"
    private static let RELAY_SETTING = "RelaySetting.json"
    //
    //
    
    
    //
    static func getSensingData(address: String, completionHandler: (_temperature: Int?, _humidity: Int?)->Void){
        if let client = Dropbox.authorizedClient {
            var temperature : Int? = nil
            var humidity : Int? = nil
            
            let destination : (NSURL, NSHTTPURLResponse) -> NSURL = { temporaryURL, response in
                let fileManager = NSFileManager.defaultManager()
                let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
                // generate a unique name for this file in case we've seen it before
                let UUID = NSUUID().UUIDString
                let pathComponent = "\(UUID)-\(response.suggestedFilename!)"
                return directoryURL.URLByAppendingPathComponent(pathComponent)
            }
            
            let path = "/\(address)/\(SENSING_INFO)"
            
            client.files.download(path: path, destination: destination).response { response, error in
                if let (metadata, url) = response {
                    print("*** Download file ***")
                    let data = NSData(contentsOfURL: url)
                    
                    let context = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
                    print(context)
                    
                    //
                    do{
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                        
                        if let temp = json["tempeature"] as? Int{
                            temperature = temp
                        }
                        if let humi = json["humidity"] as? Int{
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
}