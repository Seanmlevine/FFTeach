//
//  MultiVideoViewController.swift
//  accelerate-audio-spectrogram
//
//  Created by Sean Levine on 10/24/21.
//  Copyright © 2021 Apple. All rights reserved.
//
/*

import UIKit
import AVFoundation
import AVKit
import Accelerate

class MultiVideoViewController: UIViewController {
    
    
    @IBOutlet var containers: [VideoContainer]!
    var avPlayer: AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let videoNames = ["Bass Drum", "Noise", "Snare", "Square Wave", "Piano Scale", "Song File"]
        for (i, container) in containers.enumerated() {
            container.playVideo(withName: videoNames[i])
        }
    }
    
    func playVideo() {

        let filepath: String? = Bundle.main.path(forResource: "BassDrum", ofType: "mov")
        let fileURL = URL.init(fileURLWithPath: filepath!)

        avPlayer = AVPlayer(url: fileURL)
        let avPlayerController = AVPlayerViewController()
        avPlayerController.player = avPlayer
        avPlayerController.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)

        // Turn on video controlls
        avPlayerController.showsPlaybackControls = true

        // play video
        self.view.addSubview(avPlayerController.view)
        self.addChild(avPlayerController)
    }
}






*/



