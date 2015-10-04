//
//  SettingViewCell.swift
//  HappyHog
//
//  Created by nlplab on 2015. 10. 4..
//  Copyright © 2015년 Alexandre. All rights reserved.
//

import UIKit

class SettingViewCell : UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    class var expandedHeight: CGFloat { get {return 200 } }
    class var defaultHeight: CGFloat { get {return 44 } }
    
    func checkHeight() {
        datePicker.hidden = (frame.size.height < SettingViewCell.expandedHeight)
    }
    
    func watchFrameChanges() {
        addObserver(self, forKeyPath: "frame", options: .New, context: nil)
        checkHeight()
    }
    
    func ignoreFrameChanges() {
        
        removeObserver(self, forKeyPath: "frame")
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "frame" {
            checkHeight()
        }
    }
}