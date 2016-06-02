//
//  PetListTableViewCell.swift
//  HHHPrototype
//
//  Created by Cho YoungHun on 2015. 11. 23..
//  Copyright © 2015년 Yoonseung Choi. All rights reserved.
//

import UIKit
import Social

class PetListTableViewCell: UITableViewCell {
    @IBOutlet weak var petImage: UIImageView!
    
    @IBOutlet weak var cellToolBar: UIToolbar!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lightLabel: UILabel!
    @IBOutlet weak var humidLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    ///
    @IBOutlet weak var topView: UIView!
    ///
    
    var name: String?
    var memo: String?
    
    //var http_reference : HttpReference?
    var http_timer = NSTimer();
    
    var server_addr : String?
    
    var onButtonTapped : (() -> Void)? = nil
    
    func strToImage(name: String?) -> UIImage?{
        let Name = name
        return UIImage(named: Name!)
    }
    
    var sidePet: SidePets!{
        didSet{
            petImage.image = sidePet.image
            server_addr = sidePet.server_addr
            name = sidePet.name
            memo = sidePet.memo
            //memo = sidePet.memo
            
            //nameLabel.text = name
            
            /*http_reference = HttpReference(server_addr)
            
            let http_timer_interval:NSTimeInterval = 50.0
            
            //타이머를 설정해주면 처음 시작도 정해진 시간뒤여서 우선 맨처음 실행 후 타잇=머 설정
            getHttpMsg()
            
            http_timer = NSTimer.scheduledTimerWithTimeInterval(http_timer_interval, target: self, selector:  "getHttpMsg", userInfo:  nil, repeats: true)*/
            
            dropbox.getSensingData(server_addr!, completionHandler: {(temperature, humidity) -> Void in
                print("\(temperature)  ------ \(humidity)")
                self.temperatureLabel.text = (temperature == nil) ? "-- 도" : "\(String(temperature! as Double)) 도"
                self.humidLabel.text = (humidity == nil) ? "-- %" : "\(String(humidity! as Double)) %"
            })
            
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////
    @IBAction func clickFeed(sender: AnyObject) {
        let coredata = coreData(entity: "User")
        dataStore.feeding_index = coredata.getsearchIndex(name!, _memo: memo!, _server_addr: server_addr!)
        if let onButtonTapped = self.onButtonTapped {
            onButtonTapped()
        }
    }
    
    @IBAction func clickShare(sender: AnyObject) {
        let coredata = coreData(entity: "User")
        dataStore.isClicked = true
        dataStore.isClickedShare = true
        dataStore.index = coredata.getsearchIndex(name!, _memo: memo!, _server_addr: server_addr!)
        if let onButtonTapped = self.onButtonTapped {
            onButtonTapped()
        }
    }
    
    @IBAction func clickSetting(sender: AnyObject) {
        print("setting")
        if let onButtonTapped = self.onButtonTapped {
            onButtonTapped()
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////
    
//    func getHttpMsg(){
//        http_reference!.getResponse({(result, temperature, humidity) -> Void in
//            self.temperatureLabel.text = temperature
//            self.humidLabel.text = humidity
//            self.lightLabel.text = "--"
//        })
//    }
}

