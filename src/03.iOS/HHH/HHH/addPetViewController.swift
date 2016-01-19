//
//  SettingViewController.swift
//  HHHPrototype
//
//  Created by Yoonseung Choi on 2015. 10. 14..
//  Copyright © 2015년 Yoonseung Choi. All rights reserved.
//

import UIKit

class addPetViewController: UITableViewController {
    //var isExpanding : Bool = false
    var clickForExpanding = [false, false, false, false]
    var now_expanding : Int = -1
    var num_expanded : Int = 0
    
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var memoTxt: UITextField!
    @IBOutlet weak var serverTxt: UITextField!
    //
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 6){
            clickForExpanding[indexPath.row / 2] = !clickForExpanding[indexPath.row / 2]
            tableView.reloadData()
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
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
        
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "saveSegue"){
            //coredata save
            let credata = coreData(entity: "User")
            let dP = data_user(name: nameTxt.text!, memo: memoTxt.text!, server: serverTxt.text!) as data_user
            credata.insertData(dP)
        }
    }
    
    
}
