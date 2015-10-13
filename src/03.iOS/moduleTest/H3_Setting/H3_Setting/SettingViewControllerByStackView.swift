//
//  SettingViewController.swift
//  H3_Setting
//
//  Created by Yoonseung Choi on 2015. 10. 13..
//  Copyright © 2015년 Yoonseung Choi. All rights reserved.
//

import UIKit

let expandingCellId = "expandingCell"
let estimatedHeight: CGFloat = 300 // stack view heigh
let topInset: CGFloat = 20 // Y axis of expandingCell

class SettingViewControllerByStackView: UITableViewController{
    
    let viewModel = MainViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        tableView.contentInset.top = topInset
        tableView.estimatedRowHeight = estimatedHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count()
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(expandingCellId, forIndexPath: indexPath) as! ExpandingCellByStackView
        
        cell.characteristicOfFirst = viewModel.firstLabelForRow(indexPath.row)
        cell.placeholderOfFirst = viewModel.firstTextFieldForRow(indexPath.row)
        
        cell.characteristicOfSecond = viewModel.secondLabelForRow(indexPath.row)
        cell.placeholderOfFirst = viewModel.secondLabelForRow(indexPath.row)

        return cell
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if let selectedCellIndex = tableView.indexPathForSelectedRow where selectedCellIndex == indexPath {
            tableView.beginUpdates()
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            tableView.endUpdates()
        
            return nil
        }
        
        else { return indexPath }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }

}


struct MainViewModel {
    
    private let items = SettingItemStore.items()
    
    func count() -> Int {
        return items.count
    }
    
    func titleForRow(row: Int) -> String {
        return items[row].title
    }
    
    func firstLabelForRow(row: Int) -> String {
        return items[row].firstLabel
    }
    func firstTextFieldForRow(row: Int) -> String {
        return items[row].firstTextField
    }
    func secondLabelForRow(row: Int) -> String {
        return items[row].secondLabel
    }
    func secondTextFieldForRow(row: Int) -> String {
        return items[row].secondTextField
    }
}



struct SettingItemStore {
    static func items() -> [Item] {
        return [
            Item(title: "Profile", firstLabel: "name", firstTextField: "hello", secondLabel: "memo", secondTextField: "world"),
            Item(title: "Profile", firstLabel: "name", firstTextField: "hello", secondLabel: "memo", secondTextField: "world")

        ]
    }
}



struct Item {
    let title: String
    let firstLabel: String
    let firstTextField: String
    let secondLabel: String
    let secondTextField: String
}







