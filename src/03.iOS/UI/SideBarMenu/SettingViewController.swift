//
//  SettingViewController.swift
//  HappyHog
//
//  Created by nlplab on 2015. 10. 3..
//  Copyright © 2015년 Alexandre. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController {
    
    var settingviews = [SettingView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.settingviews = [SettingView(name:"a") , SettingView(name: "b"), SettingView(name: "c"), SettingView(name: "d")]
    }
    
    override func didReceiveMemoryWarning() {
        self.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.settingviews.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        var settingView : SettingView
        
        settingView = settingviews[indexPath.row]
        
        cell.textLabel?.text = settingView.name
        
        return cell
    }
    
}