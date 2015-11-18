//
//  HttpReference.swift
//  HHHPrototype
//
//  Created by Cho YoungHun on 2015. 11. 18..
//  Copyright © 2015년 Yoonseung Choi. All rights reserved.
//

import Foundation
//usage
//http://www.raywenderlich.com/85080/beginning-alamofire-tutorial
//github
//https://github.com/Alamofire/Alamofire
import Alamofire
//github
//https://github.com/tid-kijyun/Kanna
import Kanna

class HttpReference{
    let type_temperature = 0, type_humidity = 1
    var server_address : String?
    var response_result_value : String?
    
    
    init(_ addr: String?){
        self.server_address = addr
        print(server_address)
    }
    
    
    func getResponse(completionHandler: (result: Bool) -> Void){
        //get http source
        //use Alamofire library
        print("aaaa")
        Alamofire.request(.GET, server_address!)
            .responseString { response in
                //성공시
                if(response.result.isSuccess){
                    //self.response_result_value = response.result.value!
                    
                    //http parser library -> Kanna
                    if let doc = Kanna.HTML(html: response.result.value!, encoding: NSUTF8StringEncoding) {
                        //http 소스 중 p 태그의 2번쨰 택스트
                        self.response_result_value = doc.css("p").at(1)?.text
                        
                    }else{
                        self.response_result_value = nil
                    }
                    //Alamofire.end
                    completionHandler(result: true)
                    
                }else{
                    self.response_result_value = nil
                    completionHandler(result: false)
                }
                
        }
    }
    
    
    func getData(type : Int) -> String{
        var return_value : String = "--"
        
        if((response_result_value) != nil){
            //텍스트 분할
            //현자 텍스트는
            // 데이터1 : -- / 데이터2: -- / 데이터3: --
            //이므로 우선 " / " 으로 텍스트 분한
            let data_string_split = response_result_value!.componentsSeparatedByString(" / ")
            
            if(type == type_temperature){
                return_value = data_string_split[0].componentsSeparatedByString(": ")[1] + " 도"
            }else if(type == type_humidity){
                return_value = data_string_split[01].componentsSeparatedByString(": ")[1] + " %"
            }
        }else{
            if(type == type_temperature){
                return_value += " 도"
            }else if(type == type_humidity){
                return_value += " %"
            }
        }
        
        return return_value
    }
}

