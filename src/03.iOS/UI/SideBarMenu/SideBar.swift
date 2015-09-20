//
//  SideBar.swift
//  SideBarMenu
//
//  Created by Alexandre on 30/01/2015.
//  Copyright (c) 2015 Alexandre. All rights reserved.
//

import UIKit



//Necessary if we want to specify orptional requirements
@objc protocol SideBarDelegate{
    func sideBarDidSelectButtonAtIndex(index:Int)
    optional func sideBarWillClose()
    optional func sideBarWillOpen()
}

//When an item of the sidebar is selected, and also when the sidebar will open or close
class SideBar: NSObject, SideBarTableViewControllerDelegate {
   
    let barWidth:CGFloat                    = 150.0
    let sideBarTableViewTopInset:CGFloat    = 64.0
    let sideBarContainerView:UIView         = UIView()
    let sideBarTableViewController:SideBarTableViewController = SideBarTableViewController()
    var originView:UIView!
    
    var animator:UIDynamicAnimator!
    var delegate:SideBarDelegate!
    var isSideBarOpen:Bool = false
    
    //This init only allocate memory
    override init(){
        super.init()
    }
    
    init(sourceView:UIView, menuItems:Array<String>){
        super.init()
        
        originView = sourceView
        sideBarTableViewController.tableData = menuItems
        
        setupSideBar()
        
        animator = UIDynamicAnimator(referenceView: originView)
        
        let showGestureRecognizer:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipe:")
        showGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Left
        originView.addGestureRecognizer(showGestureRecognizer)
        
        let hideGestureRecognizer:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipe:")
        hideGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Right
        originView.addGestureRecognizer(hideGestureRecognizer)
    }
    
    func setupSideBar(){
        sideBarContainerView.frame              = CGRectMake(-barWidth - 1, originView.frame.origin.y, barWidth, originView.frame.size.height)
        sideBarContainerView.backgroundColor    = UIColor.clearColor()
        sideBarContainerView.clipsToBounds      = false
        
        //Add the sideBar to the originView
        originView.addSubview(sideBarContainerView)
        
        //blur back of the ground
        let blurView:UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
        blurView.frame = sideBarContainerView.bounds
        sideBarContainerView.addSubview(blurView)
        
        //Setup the menu/tableView
        sideBarTableViewController.delegate                     = self
        sideBarTableViewController.tableView.frame              = sideBarContainerView.bounds
        sideBarTableViewController.tableView.clipsToBounds      = false
        sideBarTableViewController.tableView.separatorStyle     = UITableViewCellSeparatorStyle.None
        sideBarTableViewController.tableView.backgroundColor    = UIColor.clearColor()
        sideBarTableViewController.tableView.scrollsToTop       = false
        sideBarTableViewController.tableView.contentInset       = UIEdgeInsetsMake(sideBarTableViewTopInset, 0, 0, 0)
        
        sideBarTableViewController.tableView.reloadData()
        
        sideBarContainerView.addSubview(sideBarTableViewController.tableView)
    }
    
    func handleSwipe(recognizer:UISwipeGestureRecognizer){
        if recognizer.direction == UISwipeGestureRecognizerDirection.Right {
            showSideBar(false)
            delegate?.sideBarWillClose?()
        } else {
            showSideBar(true)
            delegate?.sideBarWillOpen?()
        }
    }
    
    func showSideBar(shouldOpen:Bool){
        animator.removeAllBehaviors()
        isSideBarOpen = shouldOpen
        
        //The gravity modifies the open and close speed
        let gravityX:CGFloat    = (shouldOpen) ? 1 : -1
        let magnitude:CGFloat   = (shouldOpen) ? 20 : -20
        let boundaryX:CGFloat   = (shouldOpen) ? barWidth : -barWidth - 1
        
        let gravity:UIGravityBehavior   = UIGravityBehavior(items: [sideBarContainerView])
        gravity.gravityDirection        = CGVectorMake(gravityX, 0)
        animator.addBehavior(gravity)
        
        let collisionBehavior:UICollisionBehavior = UICollisionBehavior(items: [sideBarContainerView])
        collisionBehavior.addBoundaryWithIdentifier("sideBarBoundary", fromPoint: CGPointMake(boundaryX, 20), toPoint: CGPointMake(boundaryX, originView.frame.size.height))
        animator.addBehavior(collisionBehavior)
        
        let pushBehavior:UIPushBehavior = UIPushBehavior(items: [sideBarContainerView], mode: UIPushBehaviorMode.Instantaneous)
        pushBehavior.magnitude = magnitude
        animator.addBehavior(pushBehavior)
        
        let sideBarBehavior:UIDynamicItemBehavior = UIDynamicItemBehavior(items: [sideBarContainerView])
        sideBarBehavior.elasticity = 0.3
        animator.addBehavior(sideBarBehavior)
        
    }
    
    
    func sideBarControlDidSelectRow(indexPath: NSIndexPath) {
        delegate?.sideBarDidSelectButtonAtIndex(indexPath.row)
    }
 
    
}
