//
//  WebViewController.swift
//  HHHPrototype
//
//  Created by Cho YoungHun on 2015. 11. 8..
//  Copyright © 2015년 Yoonseung Choi. All rights reserved.
//

import UIKit
//usage
//http://www.raywenderlich.com/85080/beginning-alamofire-tutorial
//github
//https://github.com/Alamofire/Alamofire
import Alamofire
//github 
//https://github.com/drmohundro/SWXMLHash
import SWXMLHash
//github
//https://github.com/tid-kijyun/Kanna
import Kanna


class WebViewController: UIViewController {
    
    @IBOutlet weak var myWebView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //link webview address
        
        //set url
        let url = NSURL(string: "http://www.google.co.kr")
        //set urlrequest
        let requestObj = NSURLRequest(URL: url!)
        //load address
        myWebView.loadRequest(requestObj)
    
        
        //get http source
        //use Alamofire library
        Alamofire.request(.GET, "http://www.google.co.kr")
            .responseString { response in
                print("Success: \(response.result.isSuccess)")
                print("Response String: \(response.result.value)     ")
                
                //var xml = SWXMLHash.parse(response.result.value!)
                
                //let count = xml["html"].all.count
                
                //print("Count     \(count)")
                
                

                if let doc = Kanna.HTML(html: response.result.value!, encoding: NSUTF8StringEncoding) {
                    print("TITLE: \(doc.title)")

                    
                    // Search for nodes by CSS
                    for link in doc.css("a") {
                        print("text === \(link.text)")
                        //print("ㅎㄱㄷㄹ == \(link["class"])")
                    }
                
                    
                   /* print("Adfasdfasdfasdfasdfasdf")
                    // Search for nodes by XPath
                    for link in doc.xpath("//a | //link") {
                        print(link.text)
                        print(link["href"])
                    }*/
                }
                
            }
            /*.response { request, response, data, error in
                print(request)
                print(response)
                print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                print(error)
        }*/
        
        
    }
}
