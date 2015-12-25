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
//https://github.com/tid-kijyun/Kanna
import Kanna


class WebViewController: UIViewController {
    
    @IBOutlet weak var myWebView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //link webview address
        
        //set url
        let url = NSURL(string: "http://52.68.82.234:19918")
        //set urlrequest
        let requestObj = NSURLRequest(URL: url!)
        //load address
        myWebView.loadRequest(requestObj)
        
        
        /*.response { request, response, data, error in
        print(request)
        print(response)
        print(NSString(data: data!, encoding: NSUTF8StringEncoding))
        print(error)
        }*/
        
        
    }
}
