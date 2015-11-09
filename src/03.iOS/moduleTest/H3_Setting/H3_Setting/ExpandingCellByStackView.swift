//
//  ExpandingCell.swift
//  H3_Setting
//
//  Created by Yoonseung Choi on 2015. 10. 13..
//  Copyright © 2015년 Yoonseung Choi. All rights reserved.
//

import UIKit

class ExpandingCellByStackView: UITableViewCell {
    
    var title: String? {
        didSet {
            SettingTitleLabel.text = title
        }
    }
    
    var characteristicOfFirst: String? {
        didSet {
            FirstLabel.text = characteristicOfFirst
        }
    }
    
    var placeholderOfFirst:String? {
        didSet {
            FirstTextField.placeholder = placeholderOfFirst
        }
    }
    
    var characteristicOfSecond:String? {
        didSet {
            SecondLabel.text = characteristicOfSecond
        }
    }
    var placeholderOfSecond: String? {
        didSet {
            SecondTextField.placeholder = placeholderOfSecond
        }
    }
    
    
        @IBOutlet private weak var SettingStackView: UIStackView!
        @IBOutlet private weak var SettingTitleLabel: UILabel!
        @IBOutlet private weak var FirstLabel: UILabel!
        @IBOutlet private weak var FirstTextField: UITextField!
        @IBOutlet private weak var SecondLabel: UILabel!
        @IBOutlet private weak var SecondTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        SettingStackView.arrangedSubviews.last?.hidden = true
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
        
        UIView.animateWithDuration(0.5) {
            SettingStackView.arrangedSubviews.last?.hidden = !selected
        }
    }
}

