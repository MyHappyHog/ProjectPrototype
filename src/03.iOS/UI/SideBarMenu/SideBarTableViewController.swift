//
//  SideBarTableViewController.swift
//  SideBarMenu
//
//  Created by Alexandre on 30/01/2015.
//  Copyright (c) 2015 Alexandre. All rights reserved.
//

import UIKit

protocol SideBarTableViewControllerDelegate{
    func sideBarControlDidSelectRow(indexPath:NSIndexPath)
}

//Display all of the items to the sidebar
class SideBarTableViewController: UITableViewController {

    var delegate:SideBarTableViewControllerDelegate?
    var tableData:Array<String> = []
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return tableData.count //how many data
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell?
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
            // Configure the cell

            cell!.backgroundColor           = UIColor.clearColor()
            cell!.textLabel?.textColor      = UIColor.darkTextColor()
            
            //let selectecView:UIView         = UIView(frame: CGRect(x: 0, y: 0, width: cell!.frame.width, height: cell!.frame.height))
            //Gives the blur effect
          //  selectecView.backgroundColor    = UIColor.blackColor().colorWithAlphaComponent(0.3)
            
          //  cell!.selectedBackgroundView    = selectecView
        }
        
        cell!.textLabel?.text               = tableData[indexPath.row]

        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {  //space between data
        return 45.0
    }
    
    //Wil pass the information of the row
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.sideBarControlDidSelectRow(indexPath)
    }
}
