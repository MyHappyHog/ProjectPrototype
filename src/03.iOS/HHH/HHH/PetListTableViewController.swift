//
//  PetListTableViewController.swift
//  HHHPrototype
//
//  Created by Cho YoungHun on 2015. 11. 23..
//  Copyright © 2015년 Yoonseung Choi. All rights reserved.
//

import UIKit
import Social

/*let petData = [
    //SidePets(image: "Temp")//,
SidePets(image: "samplehog", server_addr: "http://52.68.82.234:19918")
    //SidePets(title: "2", memo: "3", image: "Temp"),
    //SidePets(title: "3", memo: "4", image: "Temp")
]*/

class PetListTableViewController: UITableViewController {
    var count : Int = 0

    @IBOutlet weak var btnAddCell: UIBarButtonItem!
    
    //var pets:[SidePets] = petData
    var pets = [SidePets]()
    
    let colors : [UIColor] = [
        UIColor(red: 16/255, green: 2/255, blue: 48/255, alpha: 1.0),
        UIColor(red: 205/255, green: 204/255, blue: 195/255, alpha: 1.0),
        UIColor(red: 41/255, green: 2/255, blue: 48/255, alpha: 1.0),
        UIColor(red: 33/255, green: 35/255, blue: 33/255, alpha: 1.0),
    ]

    override func viewDidAppear(animated: Bool) {
        let user_coredata = coreData(entity: "User")
        
        for(var i = count; i < user_coredata.getCount()!; i++){
            let image = user_coredata.getDatasIndex(i, key: "image") as! String
            let server = user_coredata.getDatasIndex(i, key: "server_addr") as! String
            
            pets.append(SidePets(name: user_coredata.getDatasIndex(i, key: "title") as? String,
                memo: user_coredata.getDatasIndex(i, key: "memo") as? String,
                image: image, server_addr: server))
            
        }
    }
    override func viewWillAppear(animated: Bool) {
        
    }
    override func viewWillDisappear(animated: Bool) {

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user_coredata = coreData(entity: "User")
        
        count = user_coredata.getCount()!
        
        for(var i = 0; i < count; i++){
            let image = user_coredata.getDatasIndex(i, key: "image") as! String
            let server = user_coredata.getDatasIndex(i, key: "server_addr") as! String
            
            pets.append(SidePets(name: user_coredata.getDatasIndex(i, key: "title") as? String,
                memo: user_coredata.getDatasIndex(i, key: "memo") as? String,
                image: image, server_addr: server))
            
        }
    
    }
    @IBAction func clickBtnAddCell(sender: AnyObject) {
        self.revealViewController().revealToggleAnimated(true)
        dataStore.isClicked = true
        dataStore.isClickedAdd = true
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
        cell.cellToolBar.barTintColor = colors[indexPath.row % 4]
        
        cell.onButtonTapped = {
            //Do whatever you want to do when the button is tapped here
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
                let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                let index = dataStore.index
                let coredata = coreData(entity: "User")
                facebookSheet.setInitialText("name : \(coredata.getDatasIndex(index!, key: "title"))    memo : \(coredata.getDatasIndex(index!, key: "memo"))")
                self.presentViewController(facebookSheet, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        print(indexPath.row)
        
        /*if indexPath.row == pets.count - 1{
        pets.append(SidePets(title:"5",memo: "634", image: "Temp"))
        
        let indexPath = NSIndexPath(forRow: pets.count-1, inSection: 0)
        
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }*/
    }
}
