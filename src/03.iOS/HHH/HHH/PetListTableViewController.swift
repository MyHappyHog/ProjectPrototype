//
//  PetListTableViewController.swift
//  HHHPrototype
//
//  Created by Cho YoungHun on 2015. 11. 23..
//  Copyright © 2015년 Yoonseung Choi. All rights reserved.
//

import UIKit
import Social

class PetListTableViewController: UITableViewController, UIGestureRecognizerDelegate {
    
    
    @IBOutlet weak var btnAddCell: UIBarButtonItem!
    
    var count : Int = 0
    var pets = [SidePets]()
    
    let colors : [UIColor] = [
        UIColor(red: 16/255, green: 2/255, blue: 48/255, alpha: 1.0),
        UIColor(red: 205/255, green: 204/255, blue: 195/255, alpha: 1.0),
        UIColor(red: 41/255, green: 2/255, blue: 48/255, alpha: 1.0),
        UIColor(red: 33/255, green: 35/255, blue: 33/255, alpha: 1.0),
    ]
    
    override func viewDidAppear(animated: Bool) {
        //        user_coredata = coreData(entity: "User")
        //        for(var i = count; i < user_coredata!.getCount()!; i++){
        //            let image : UIImage? = UIImage(data: user_coredata!.getDatasIndex(i, key: "image") as! NSData)
        //            let server = user_coredata!.getDatasIndex(i, key: "server_addr") as! String
        //
        //            pets.append(SidePets(name: user_coredata!.getDatasIndex(i, key: "title") as? String,
        //                memo: user_coredata!.getDatasIndex(i, key: "memo") as? String,
        //                image: image, server_addr: server))
        //
        //        }
        pets.removeAll()
        
        user_coredata = coreData(entity: "User")
        
        count = user_coredata!.getCount()!
        
        for(var i = 0; i < count; i++){
            let image : UIImage? = UIImage(data: user_coredata!.getDatasIndex(i, key: "image") as! NSData)
            let server = user_coredata!.getDatasIndex(i, key: "server_addr") as! String
            
            pets.append(SidePets(name: user_coredata!.getDatasIndex(i, key: "title") as? String,
                memo: user_coredata!.getDatasIndex(i, key: "memo") as? String,
                image: image, server_addr: server))
            
        }
        count = user_coredata!.getCount()!
        self.tableView.reloadData()
    }
    override func viewWillAppear(animated: Bool) {
        
    }
    override func viewWillDisappear(animated: Bool) {
        
    }
    var user_coredata : coreData?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*user_coredata = coreData(entity: "User")
        
        count = user_coredata!.getCount()!
        
        for(var i = 0; i < count; i++){
        let image : UIImage? = UIImage(data: user_coredata!.getDatasIndex(i, key: "image") as! NSData)
        let server = user_coredata!.getDatasIndex(i, key: "server_addr") as! String
        
        pets.append(SidePets(name: user_coredata!.getDatasIndex(i, key: "title") as? String,
        memo: user_coredata!.getDatasIndex(i, key: "memo") as? String,
        image: image, server_addr: server))
        
        }*/
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "longPress:")
        self.view.addGestureRecognizer(longPressRecognizer)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 300.0
    }
    
    func longPress(longPressGestureRecognizer: UIGestureRecognizer){
        if longPressGestureRecognizer.state == UIGestureRecognizerState.Began {
            
            let touchPoint = longPressGestureRecognizer.locationInView(self.view)
            if let indexPath = tableView.indexPathForRowAtPoint(touchPoint) {
                //print(indexPath.row)
                // your code here, get the row for the indexPath or do whatever you want
                
                
                
                let optionMenu = UIAlertController(title: nil, message:  "Choose Option", preferredStyle: .ActionSheet)
                
                let deleteAction = UIAlertAction(title: "Delete", style: .Default, handler: {
                    (alert: UIAlertAction!) -> Void in
                    print("deleteeeeeeeee")
                    let click_index = indexPath.row
                    
                    //item delete
                    coreData.deleteItem("User", index: click_index)
                    
                    let profile_coredata = coreData(entity: "Profile")
                    if click_index < profile_coredata.getDatasIndex(0, key: "user_index") as! Int{
                        profile_coredata.setProfile(click_index)
                        dataStore.profile_index = click_index
                        
                    }else if click_index == profile_coredata.getDatasIndex(0, key: "user_index") as! Int{
                        let user = coreData(entity: "User")
                        if user.getCount() > 1{
                            dataStore.profile_index = 0
                        }
                    }
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("asdf", object: self)
                    
                    let coredata = coreData(entity: "Alarm")
                    for(var i = coredata.getCount()! - 1; i >= 0 ; i--){
                        let data_index: Int = coredata.getDatasIndex(i, key: "user_number") as! Int
                        if data_index == click_index{
                            coreData.deleteItem("Alarm", index: i)
                        }else if data_index > click_index{
                            coredata.setTimer(i, num: data_index - 1)
                        }
                    }
                })
                
                let setProfile = UIAlertAction(title: "Profile", style: .Default, handler: {
                    (alert: UIAlertAction!) -> Void in
                    dataStore.profile_index = indexPath.row
                    NSNotificationCenter.defaultCenter().postNotificationName("asdf", object: self)
                })
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
                    (alert: UIAlertAction!) -> Void in
                    print("cancel")
                })
                
                optionMenu.addAction(deleteAction)
                optionMenu.addAction(setProfile)
                optionMenu.addAction(cancelAction)
                
                self.presentViewController(optionMenu, animated: true, completion: nil)
                self.revealViewController().revealToggleAnimated(true)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pets.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PetListTableViewCell", forIndexPath: indexPath) as! PetListTableViewCell
        let pet = pets[indexPath.row] as SidePets
        cell.sidePet = pet
        //print(pet)
        //cell.cellToolBar.barTintColor = colors[indexPath.row % 4]
        
        cell.topView.backgroundColor = colors[indexPath.row % 4]
        cell.nameLabel.text = user_coredata!.getDatasIndex(indexPath.row, key: "title") as? String
        cell.petImage.image = UIImage(data: user_coredata!.getDatasIndex(indexPath.row, key: "image") as! NSData)
        
        cell.onButtonTapped = {
            //feedding
            //dataStore.feed_index
            print("feeeeeeed")
        }
        /*cell.onButtonTapped = {
        //Do whatever you want to do when the button is tapped here
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
        let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        let index = dataStore.now_index
        let coredata = coreData(entity: "User")
        facebookSheet.setInitialText("name : \(coredata.getDatasIndex(index!, key: "title"))    memo : \(coredata.getDatasIndex(index!, key: "memo"))")
        self.presentViewController(facebookSheet, animated: true, completion: nil)
        } else {
        let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        }
        }*/
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //print(indexPath.row)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "add"{
            dataStore.prev_vc = "add"
            dataStore.numOfUser = pets.count
            self.revealViewController().revealToggleAnimated(true)
            
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////
    
    
    
    @IBAction func clickBtnAddCell(sender: AnyObject) {
        self.revealViewController().revealToggleAnimated(true)
        //dataStore.isClicked = true
        //dataStore.isClickedAdd = true
        dataStore.prev_vc = "add"
        dataStore.numOfUser = pets.count
    }
    
    
}
