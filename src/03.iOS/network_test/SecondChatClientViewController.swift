//
//  SecondChatClientViewController.swift
//
//  Created by Musawar Ahmed on 6/7/15.
//  Copyright (c) 2015 Musawar. All rights reserved.
//

import UIKit

class SecondChatClientViewController: UIViewController,UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, NSStreamDelegate {

    var inputStream : NSInputStream!
    var outputStream : NSOutputStream!
    
    var messages:NSMutableArray = []

    @IBOutlet var tView: UITableView!
    @IBOutlet var inputMessageField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tView.delegate = self
        self.tView.dataSource = self
        inputStream.delegate = self
        inputStream.open()
        
        self.inputMessageField.delegate = self
       
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }
    
   
    @IBAction func sendMessage(sender: UIButton) {
        
        performAction()
    }
    
    func performAction(){
        
        var responce:NSString = "msg:"+"\(inputMessageField.text)"
        let data: NSData = responce.dataUsingEncoding(NSUTF8StringEncoding)!
        outputStream.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
        inputMessageField.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()  
        performAction()
        return true
    }
    
    // Now listening to the data sent by the server
    func stream(theStream: NSStream,handleEvent streamEvent: NSStreamEvent){
        //println("stream event \(streamEvent)")
        
        switch(streamEvent){
            
        case NSStreamEvent.OpenCompleted:
            println("Stream Opened")
            //here you can do some work you want
            break
//- - - - - - - - - - - - - - - - - - - - - - - -
        case NSStreamEvent.HasBytesAvailable:
            if theStream == inputStream{
    
                let bufferSize = 1024
                var buffer = Array<UInt8>(count: bufferSize, repeatedValue: 0)
                
                while inputStream.hasBytesAvailable{
                    
                    let bytesRead = inputStream.read(&buffer, maxLength: bufferSize)
                    if bytesRead != 0 {
                        var output = NSString(bytes: &buffer, length: bytesRead, encoding: NSUTF8StringEncoding)
                        
                        if output != nil{
                            self.messageReceived(output!)
                        }
                    }
                    
                }
            }
            break
//- - - - - - - - - - - - - - - - - - - - - - - -
        case NSStreamEvent.EndEncountered:
            theStream.close()
            theStream.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
            println("ignore")
            break
        case NSStreamEvent.HasSpaceAvailable:
            println("space available")
            //here you can do some work you want
            break
            
        default:
            println("Unknown Event")
            //here you can do some what ever you want
        
        }//end of switch
        
    }//end of stream function
    
    //save the data received; in to the message string
    func messageReceived(msgs:NSString){
        println("message received is \(msgs)")
        self.messages.addObject(msgs)
        self.tView.reloadData()
        var topIndexPath:NSIndexPath = NSIndexPath(forRow: messages.count-1, inSection: 0)
        self.tView.scrollToRowAtIndexPath(topIndexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
    }
    
    // show the data into the TableView
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let CellIdentifier:NSString = "CellIdentifier"
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier as String, forIndexPath: indexPath) as! UITableViewCell
        
        var s:String = messages.objectAtIndex(indexPath.row) as! String
        cell.textLabel!.text = s

        return cell
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> NSInteger {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: NSInteger) -> NSInteger {
        return messages.count;
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
