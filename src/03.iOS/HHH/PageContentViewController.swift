//
//  PageContentViewController.swift
//  HHH
//
//  Created by Cho YoungHun on 2016. 5. 9..
//  Copyright © 2016년 hhh. All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController {

    @IBOutlet weak var bkImageView: UIImageView?
    
    var itemIndex: Int = 0
    var imageName: String = "" {
        
        didSet {
            
            if let imageView = bkImageView {
                imageView.image = UIImage(named: imageName)
            }
            
        }
    }
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bkImageView!.image = UIImage(named: imageName)
    }
    
}
