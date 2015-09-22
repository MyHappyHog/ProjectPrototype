//
//  SettingViewController.swift
//  SideBarMenu
//
//  Created by nlplab on 2015. 9. 22..
//  Copyright © 2015년 Alexandre. All rights reserved.
//

import UIKit

class SettingviewController: UITableViewController {
    var candies = [Candy]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.candies = [Candy(name : "one"),Candy(name : "two"),Candy(name : "three"),Candy(name : "four")]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) ->Int {
        return self.candies.count
    }
    
    override func tableView(tableview: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
    -> UITableViewCell
    {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
                as UITableViewCell
            
            var candy : Candy
            
            candy = candies[indexPath.row]
            
            cell.textLabel?.text = candy.name
            
            return cell
    }
}