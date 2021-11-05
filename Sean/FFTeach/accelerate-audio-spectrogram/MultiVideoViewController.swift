//
//  MultiVideoViewController.swift
//  accelerate-audio-spectrogram
//
//  Created by Sean Levine on 11/3/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class MultiVideoViewController: UIViewController {
    
    @IBOutlet var containers: [VideoContainer]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let videoNames = ["BassDrum", "Noise", "PianoCScale", "Snare", "SongFile", "SquareWave"]
        for (i, container) in containers.enumerated() {
            container.playVideo(withName: videoNames[i])
        }
    }
    
}
