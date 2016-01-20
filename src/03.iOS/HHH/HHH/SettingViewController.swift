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
    var clickForExpanding = [false, false, false, false]
    var now_expanding : Int = -1
    var num_expanded : Int = 0
    
    @IBOutlet weak var textfieldMinTemperature: UITextField!
    @IBOutlet weak var textfieldMaxTemperature: UITextField!
    @IBOutlet weak var textfieldMinHunidity: UITextField!
    @IBOutlet weak var textfieldMaxHumidity: UITextField!
    
    @IBOutlet weak var textfieldName: UITextField!
    @IBOutlet weak var textfieldMemo: UITextField!
    @IBOutlet weak var textfieldServer: UITextField!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let coredata = coreData(entity: "User")
        if(coredata.getCount() != 0){
            let index = dataStore.index!
            self.textfieldName.text = coredata.getDatasIndex(index, key: "title") as? String
            self.textfieldMemo.text = coredata.getDatasIndex(index, key: "memo") as? String
            self.textfieldServer.text = coredata.getDatasIndex(index, key: "server_addr") as? String
            
            print(coredata.getDatasIndex(index, key: "minTemp") as! Int)
            self.textfieldMinTemperature.text = String(coredata.getDatasIndex(index, key: "minTemp") as! Int)
            self.textfieldMaxTemperature.text = String(coredata.getDatasIndex(index, key: "maxTemp") as! Int)
            self.textfieldMinHunidity.text = String(coredata.getDatasIndex(index, key: "minhum") as! Int)
            self.textfieldMaxHumidity.text = String(coredata.getDatasIndex(index, key: "maxhum") as! Int)
        }
        
    }
  
    
    @IBAction func clickSaveBtn(sender: AnyObject) {
        let coredata = coreData(entity: "User")
        let http_reference = HttpReference(coredata.getDatasIndex(0, key: "server_addr") as? String)
        
        if textfieldMaxTemperature == nil{

        }
        
        
        http_reference.postSensorData(Int((textfieldMaxTemperature.text! as String))!,
            minTemprature: Int((textfieldMinTemperature.text! as String))!,
            maxHumidity: Int((textfieldMaxHumidity.text! as String))!,
            minHumidity: Int((textfieldMinHunidity.text! as String))!)
        
        
        
        self.navigationController?.popViewControllerAnimated(true)
    }
}
