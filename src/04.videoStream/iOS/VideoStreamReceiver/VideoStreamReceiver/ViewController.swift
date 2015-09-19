//
//  ViewController.swift
//  VideoStreamReceiver
//
//  Created by Yoonseung Choi on 2015. 9. 18..
//  Copyright © 2015년 Yoonseung Choi. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {


    @IBOutlet weak var AVPlayerView: UIView!
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // yoon // from local file
//        let path = NSBundle.mainBundle().pathForResource("vid_bigbuckbunny", ofType: "mp4")!
//        let sampleURL = NSURL(fileURLWithPath: path)
//        let playerItem = AVPlayerItem(URL: sampleURL)
//        let player = AVPlayer(playerItem: playerItem)
        
        // yoon // from web
        let sampleURL = NSURL(string: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")!
        let player = AVPlayer(URL: sampleURL)
        
        
        let playerLayer = AVPlayerLayer(player: player)
        
        let videoWidth = 320
        let videoHeigh = 180
        let screenWidth = self.view.frame.size.width
        let screenHeigh = self.view.frame.size.height
        
        playerLayer.frame = CGRectMake(
            (screenWidth/2 - CGFloat(videoWidth/2)),
            (screenHeigh/2 - CGFloat(videoHeigh/2)),
            CGFloat(videoWidth),
            CGFloat(videoHeigh))
        AVPlayerView.layer.addSublayer(playerLayer)

        
        player.play()
        
        //AVPlayerView.backgroundColor = UIColor.blackColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    
    

}

