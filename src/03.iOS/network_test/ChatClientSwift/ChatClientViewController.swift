//
//  ViewController.swift
//  ChatClientSwift
//
//  Created by Musawar Ahmed on 5/29/15.
//  Copyright (c) 2015 musawar. All rights reserved.
//

import UIKit

class ChatClientViewController: UIViewController, NSStreamDelegate, UITextFieldDelegate{

    @IBOutlet weak var inputNameField: UITextField!
    @IBOutlet var joinView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputNameField.text = "Seongsil"
        self.initNetworkCommunication()
        self.inputNameField.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    var outputStream: NSOutputStream!
    var inputStream: NSInputStream!
    
    func initNetworkCommunication(){
        
        let serverAddress: CFString = "localhost"
        let serverPort: UInt32 = 89
        
        var readStream:  Unmanaged<CFReadStreamRef>?
        var writeStream: Unmanaged<CFWriteStreamRef>?
        
        CFStreamCreatePairWithSocketToHost(nil, serverAddress, serverPort, &readStream, &writeStream)
        
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()

        //inputStream.delegate = self
        outputStream.delegate = self
        inputStream.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        outputStream.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        
        //inputStream.open()
        outputStream.open()
    }
    
    @IBAction func joinChat(sender: AnyObject) {
        performAction()
    }
    
    func performAction(){
        
        var response = "iam:"+"\(inputNameField.text)"
        let data: NSData = response.dataUsingEncoding(NSUTF8StringEncoding)!
        outputStream.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
        
        inputNameField.resignFirstResponder()
        //- - - - Now sending data to next view controller
        
        var viewController2Object : SecondChatClientViewController = getViewController("ViewController2StoryBoardName") as! SecondChatClientViewController
        viewController2Object.inputStream = inputStream
        viewController2Object.outputStream = outputStream
        self.presentViewController(viewController2Object, animated: true, completion: nil)
    }
    

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        performAction()
        return true
    }
    
    func getViewController(storyBoard: NSString) -> UIViewController{
        
        var mystoryBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var ViewControllerID : UIViewController = mystoryBoard.instantiateViewControllerWithIdentifier(storyBoard as String) as! UIViewController
        return ViewControllerID
    }
}



