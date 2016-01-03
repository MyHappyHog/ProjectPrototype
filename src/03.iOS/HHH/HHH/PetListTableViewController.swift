//
//  PetListTableViewController.swift
//  HHHPrototype
//
//  Created by Cho YoungHun on 2015. 11. 23..
//  Copyright © 2015년 Yoonseung Choi. All rights reserved.
//

import UIKit

/*let petData = [
    SidePets(image: "Temp")//,
    //SidePets(title: "2", memo: "3", image: "Temp"),
    //SidePets(title: "3", memo: "4", image: "Temp")
]*/

class PetListTableViewController: UITableViewController {


    @IBOutlet weak var btnAddCell: UIBarButtonItem!
    
    //var pets:[SidePets] = petData
    var pets = [SidePets]()
    
    let colors : [UIColor] = [
        UIColor(red: 16/255, green: 2/255, blue: 48/255, alpha: 1.0),
        UIColor(red: 205/255, green: 204/255, blue: 195/255, alpha: 1.0),
        UIColor(red: 41/255, green: 2/255, blue: 48/255, alpha: 1.0),
        UIColor(red: 33/255, green: 35/255, blue: 33/255, alpha: 1.0),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    @IBAction func clickBtnAddCell(sender: AnyObject) {
        pets.append(SidePets(image: "samplehog", server_addr: "http://52.68.82.234:19918"))
        
        let indexPath = NSIndexPath(forRow: pets.count-1, inSection: 0)
        
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
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
        print(pet)
        cell.cellToolBar.barTintColor = colors[pets.count % 4]
        
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
