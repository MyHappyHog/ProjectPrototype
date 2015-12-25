//
//  PetListTableViewController.swift
//  HHHPrototype
//
//  Created by Cho YoungHun on 2015. 11. 23..
//  Copyright © 2015년 Yoonseung Choi. All rights reserved.
//

import UIKit

let petData = [
    SidePets(title: "1", memo: "2", image: "Temp")//,
    //SidePets(title: "2", memo: "3", image: "Temp"),
    //SidePets(title: "3", memo: "4", image: "Temp")
]

class PetListTableViewController: UITableViewController {
    
    var pets:[SidePets] = petData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        //cell.titleLabel?.text = pet.title
        //cell.memoLabel?.text = pet.memo
        //cell.imageView?.image = UIImage(named: pet.image!)
        cell.sidePet = pet
        print(pet)
        
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        print(indexPath.row)
        if indexPath.row == pets.count - 1{
            pets.append(SidePets(title:"5",memo: "634", image: "Temp"))
            
            let indexPath = NSIndexPath(forRow: pets.count-1, inSection: 0)
            
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
}
