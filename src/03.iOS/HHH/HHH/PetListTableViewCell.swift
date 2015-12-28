//
//  PetListTableViewCell.swift
//  HHHPrototype
//
//  Created by Cho YoungHun on 2015. 11. 23..
//  Copyright © 2015년 Yoonseung Choi. All rights reserved.
//

import UIKit

class PetListTableViewCell: UITableViewCell {
    @IBOutlet weak var petImage: UIImageView!
    
    
    @IBOutlet weak var lightLabel: UILabel!
    @IBOutlet weak var humidLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    var http_reference : HttpReference?
    var http_timer = NSTimer();

    var server_addr : String?
    
    func strToImage(name: String?) -> UIImage?{
        let Name = name
        return UIImage(named: Name!)
    }
    var sidePet: SidePets!{
        didSet{
            petImage.image = strToImage(sidePet.image)
            server_addr = sidePet.server_addr
            
            http_reference = HttpReference(server_addr)
            
            let http_timer_interval:NSTimeInterval = 50.0
            
            //타이머를 설정해주면 처음 시작도 정해진 시간뒤여서 우선 맨처음 실행 후 타잇=머 설정
            changeData()
            
            http_timer = NSTimer.scheduledTimerWithTimeInterval(http_timer_interval, target: self, selector:  "changeData", userInfo:  nil, repeats: true)
            
        }
    }
    
    func changeData(){
        http_reference!.getResponse({(result, temperature, humidity) -> Void in
            if(result == true){
                //self.TempLabel.text = self.http_reference!.getData(0)
                //self.HumidLabel.text = self.http_reference!.getData(1
                self.temperatureLabel.text = temperature
                self.humidLabel.text = humidity
                self.lightLabel.text = "--"
            }else{
                self.temperatureLabel.text = temperature
                self.humidLabel.text = humidity
                self.lightLabel.text = "--"
                return
            }
        })
    }
    
}

