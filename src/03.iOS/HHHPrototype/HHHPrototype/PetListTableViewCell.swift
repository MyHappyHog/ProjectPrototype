//
//  PetListTableViewCell.swift
//  HHHPrototype
//
//  Created by Cho YoungHun on 2015. 11. 23..
//  Copyright © 2015년 Yoonseung Choi. All rights reserved.
//

import UIKit

class PetListTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var petImage: UIImageView!
    
    func strToImage(name: String?) -> UIImage?{
        let Name = name
        return UIImage(named: Name!)
    }
    var sidePet: SidePets!{
        didSet{
            titleLabel.text = sidePet.title
            memoLabel.text = sidePet.memo
            petImage.image = strToImage(sidePet.image)
        }
    }
    
}

