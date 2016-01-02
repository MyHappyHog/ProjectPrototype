//
//  SettingViewController.swift
//  HHHPrototype
//
//  Created by Yoonseung Choi on 2015. 10. 14..
//  Copyright © 2015년 Yoonseung Choi. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController {
    //var isExpanding : Bool = false
    var clickForExpanding = [false, false, false]
    var now_expanding : Int = -1
    var num_expanded : Int = 0
    
    //
    
    
    
    func cellHeight(index: Int) -> CGFloat{
        if(index == 1){
            return 200.0
        }else if(index == 3){
            return 300.0
        }else{
            return 44.0
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {


        /*if(indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4){
            if(isExpanding){
                if(now_expanding == indexPath.row){
                    num_expanded--
                    if(num_expanded == 0){
                        isExpanding = !isExpanding
                    }
                }else{
                    now_expanding = indexPath.row
                    num_expanded++
                }
            }
            tableView.reloadData()
        }*/
        
        if(indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4){
            clickForExpanding[indexPath.row / 2] = !clickForExpanding[indexPath.row / 2]
            tableView.reloadData()
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        /*if indexPath.row > 0 && indexPath.row < 5{// && clikedProfile == false {
            return 0.0
        }*/
        /*if indexPath.row == 2 {
        if clikedProfile == false || clikedProfile == false {
        return 0.0
        }
        return 165.0
        }*/        
        let index = indexPath.row
        
        if(index == 1){
            if(clickForExpanding[0]){
                return 200.0
            }else{
                return 0.0
            }
        }else if(index == 3){
            if(clickForExpanding[1]){
                return 300.0
            }else{
                return 0.0
            }
        }
        
        return 44.0
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    //////
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }    
}
