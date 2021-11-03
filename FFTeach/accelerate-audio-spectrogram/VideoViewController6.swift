//
//  VideoViewController6.swift
//  accelerate-audio-spectrogram
//
//  Created by Joseph Taylor on 10/24/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import AVFoundation
import Accelerate
import UIKit
import AVKit

class VideoViewController6: UIViewController {
    
    var avPlayer: AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playVideo()
    }
    
    func playVideo() {

        let filepath: String? = Bundle.main.path(forResource: "SquareWave", ofType: "mov")
        let fileURL = URL.init(fileURLWithPath: filepath!)

        avPlayer = AVPlayer(url: fileURL)
        let avPlayerController = AVPlayerViewController()
        avPlayerController.player = avPlayer
        avPlayerController.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)

        // Turn on video controlls
        avPlayerController.showsPlaybackControls = true

        // play video
        //avPlayerController.player?.play()
        self.view.addSubview(avPlayerController.view)
        self.addChild(avPlayerController)
    }
}
