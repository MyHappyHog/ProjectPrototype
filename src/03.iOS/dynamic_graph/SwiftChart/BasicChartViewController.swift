//
//  BasicChartViewController.swift
//  SwiftChart
//
//  Created by Giampaolo Bellavite on 07/11/14.
//  Copyright (c) 2014 Giampaolo Bellavite. All rights reserved.
//

import UIKit

class BasicChartViewController: UIViewController, ChartDelegate {
    @IBOutlet weak var chart: Chart!
    var selectedChart = 0
    
    override func viewDidLoad() {
        
        // Draw the chart selected from the TableViewController
        
        chart.delegate = self
        
        switch selectedChart {
        case 0:
            
            let chart2 = Chart(frame: CGRect(x: 0, y: 0, width: 100, height: 200))
            
            // Simple chart
            let series = ChartSeries([0, 6, 2, 8, 4, 7, 3, 10, 8])
            series.color = ChartColors.greenColor()
            chart.addSeries(series)
            
            
        case 1:
            
            // Example with multiple series, the first two with area enabled
            
            let series1 = ChartSeries([0, 6, 2, 8, 4, 7, 3, 10, 8])
            series1.color = ChartColors.yellowColor()
            series1.area = true
            
            let series2 = ChartSeries([1, 0, 0.5, 0.2, 0, 1, 0.8, 0.3, 1])
            series2.color = ChartColors.redColor()
            series2.area = true
            
            // A partially filled series
            let series3 = ChartSeries([9, 8, 10, 8.5, 9.5, 10])
            series3.color = ChartColors.purpleColor()
            
            chart.addSeries([series1, series2, series3])
            
        default: break;
            
        }
        
        
    }
    
    // Chart delegate
    
    func didTouchChart(chart: Chart, indexes: Array<Int?>, x: Float, left: CGFloat) {
        for (seriesIndex, dataIndex) in enumerate(indexes) {
            if let value = chart.valueForSeries(seriesIndex, atIndex: dataIndex) {
                println("Touched series: \(seriesIndex): data index: \(dataIndex!); series value: \(value); x-axis value: \(x) (from left: \(left))")
            }
        }
    }
    
    func didFinishTouchingChart(chart: Chart) {
        
    }
    
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        // Redraw chart on rotation
        chart.setNeedsDisplay()
        
    }
    
}
