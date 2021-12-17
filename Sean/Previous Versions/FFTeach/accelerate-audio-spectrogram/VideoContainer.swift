//
//  VideoView.swift
//  accelerate-audio-spectrogram
//
//  Created by Sean Levine on 11/3/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class VideoContainer: UIView {
    
    var avPlayer: AVPlayer!
    var playerController: AVPlayerViewController!
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        setupPlayer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerController.view.frame = self.bounds
    }
    
    func setupPlayer() {
        avPlayer = AVPlayer()
        playerController = AVPlayerViewController()
        playerController.player = avPlayer
        playerController.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        
        // Turn on video controlls
        playerController.showsPlaybackControls = true

        // play video
        self.addSubview(playerController.view)
    }
    
    func playVideo(withName name: String) {
        let filepath: String? = Bundle.main.path(forResource: name, ofType: "mov")
        let fileURL = URL.init(fileURLWithPath: filepath!)
        avPlayer = AVPlayer(url: fileURL)
        playerController.player = avPlayer
    }
}
