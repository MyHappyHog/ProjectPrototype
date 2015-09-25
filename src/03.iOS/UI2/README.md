# ExpandableTableViewController

## Description

Swift library to easily show, hide and customize table view cells as an expandable list of items.

![alt tag](https://raw.github.com/enricmacias/ExpandableTableViewController/master/Preview/preview.gif)

## Requirements

- iOS 7.0
- UIKit

## Usage

1. Implement your UITableViewController class with ExpandableTableViewController and ExpandableTableViewDatasource, ExpandableTableViewDelegate protocols.

	```swift
	class DemoTableViewController: ExpandableTableViewController, ExpandableTableViewDelegate, ExpandableTableViewDatasource {
		...
	}
	```
2. In your Storyboard, connect the IBOutlet expandableTableView with your current UITableView object.

	Image
3. In your Storyboard, set the UITableView object with the ExpandableTableView class.

	Image
4. Set the expandableDatasource and expandableDelegate properties to self in your viewDidLoad()

	```swift
	override func viewDidLoad() {
		super.viewDidLoad()
	        
		self.expandableTableView.expandableDelegate = self
		self.expandableTableView.expandableDatasource = self
	}
	```
5. Add and implement the ExpandableTableViewDatasource required methods:

	```swift
	// Rows
	func expandableTableView(expandableTableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int
	func expandableTableView(expandableTableView: ExpandableTableView, cellForRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> UITableViewCell
	func expandableTableView(expandableTableView: ExpandableTableView, heightForRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> CGFloat
	func expandableTableView(expandableTableView: ExpandableTableView, estimatedHeightForRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> CGFloat

	// Subrows
	func expandableTableView(expandableTableView: ExpandableTableView, numberOfSubRowsInRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> Int
	func expandableTableView(expandableTableView: ExpandableTableView, subCellForRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> UITableViewCell
	func expandableTableView(expandableTableView: ExpandableTableView, heightForSubRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> CGFloat
	func expandableTableView(expandableTableView: ExpandableTableView, estimatedHeightForSubRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> CGFloat
	```
6. Add and implement the ExpandableTableViewDelegate required methods:

	```swift
	// Rows
	func expandableTableView(expandableTableView: ExpandableTableView, didSelectRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath)

	// Subrows
	func expandableTableView(expandableTableView: ExpandableTableView, didSelectSubRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath)
	```
7. You are done.

## Installation

#### Cocoapods

In development

#### Manually

Import the following files into your project:

DemoExpandableTableViewController/ExpandableTableViewController folder:
```ruby
ExpandableTableViewController.swift
ExpandableTableViewDatasource.swift
ExpandableTableViewDelegate.swift
ArrayExtension.swift
```

## Author

enric.macias.lopez, enric.macias.lopez@gmail.com

## License

ExpandableTableViewController is available under the MIT license. See the LICENSE file for more info.
