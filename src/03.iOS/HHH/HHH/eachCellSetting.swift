//
//  eachCellSetting.swift
//  HHH
//
//  Created by Cho YoungHun on 2016. 1. 18..
//  Copyright © 2016년 hhh. All rights reserved.
//

import UIKit

class eachCellSetting: UITableViewController {
    //var isExpanding : Bool = false
    var clickForExpanding = [false, false, false, false]
    var now_expanding : Int = -1
    var num_expanded : Int = 0
    
    //
    
    
    
    func cellHeight(index: Int) -> CGFloat{
        if(index == 1){
            return 400.0
        }else if(index == 3){
            return 200.0
        }else if(index == 5){
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
        
        if(indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 6){
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
                return 400.0
            }else{
                return 0.0
            }
        }else if(index == 3){
            if(clickForExpanding[1]){
                return 200.0
            }else{
                return 0.0
            }
        }else if(index == 5){
            if(clickForExpanding[2]){
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
    
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var memoTxt: UITextField!
    @IBOutlet weak var serverTxt: UITextField!
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "saveSegue"){
            //coredata save
            let credata = coreData(entity: "User")
            //let dP = data_user(name: nameTxt.text!, memo: memoTxt.text!, server: serverTxt.text!) as data_user
            //credata.insertData(dP)
        }
    }
    
    
}