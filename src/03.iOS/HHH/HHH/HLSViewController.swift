//
//  HLSViewController.swift
//  HHHPrototype
//
//  Created by ChoiYoonseung on 2015. 10. 28..
//  Copyright © 2015년 Yoonseung Choi. All rights reserved.
//

// HTTP Live Streaming(HLS): HTTP-based media streaming communications protocol implemented by Apple Inc.

// Add 'App Transport Security Settings' in Info.plist to eliminate blocking http stream because of insecure situation

import UIKit
import AVKit
import AVFoundation
import MediaPlayer

class HLSViewController: UIViewController {
    
    @IBOutlet weak var AVPlayerView: UIView!
    
    let sampleURL = NSURL(string: "http://tvcast.naver.com/v/608379")!//http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8")!
    var player:AVPlayer!
    
    
    var moviePlayer:MPMoviePlayerController!

    
    override func shouldAutorotate() -> Bool {
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*player = AVPlayer(URL: sampleURL)
        
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
        
        
        player.play()*/
        var url:NSURL = NSURL(string: "https://youtu.be/VWgr_wNtGPM")!
        
        moviePlayer = MPMoviePlayerController(contentURL: url)
        moviePlayer.view.frame = CGRect(x: 20, y: 100, width: 200, height: 150)
        
        self.view.addSubview(moviePlayer.view)
        moviePlayer.fullscreen = true
        
        moviePlayer.controlStyle = MPMovieControlStyle.Embedded

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func BackButtonPushed(sender: AnyObject) {
        //player.pause()
        performSegueWithIdentifier("IntroFromHLS", sender: nil)
    }

    @IBAction func TakePicButtonPushed(sender: AnyObject) {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "IntroFromHLS" :
            player.pause()
            break;
        default:
            break;
        }
    }
    
}