//
//  SpectrogramViewController.swift
//  accelerate-audio-spectrogram
//
//  Created by Joseph Taylor on 10/22/21.
//  Copyright © 2021 Apple. All rights reserved.
//
import AVFoundation
import Accelerate
import UIKit

class SpectrogramViewController: UIViewController {

    // Creates an audioSpectrogram object. This object will be made visible later by inserting it into a Sublayer. Note that you must add a "Privacy - Microphone Usage Description" entry to 'Info.plist' in order to allow the audioSpectrogram microphone access.
    var audioSpectrogram = AudioSpectrogram()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioSpectrogram.contentsGravity = .resize
        view.layer.addSublayer(audioSpectrogram)
  
        view.backgroundColor = .black
        audioSpectrogram.startRunning()
    }
    
    func set(sampleCount: Int, bufferCount: Int, hopCount: Int) {
        audioSpectrogram.removeFromSuperlayer()
        
        audioSpectrogram = AudioSpectrogram()
        audioSpectrogram.sampleCount = sampleCount
        audioSpectrogram.bufferCount = bufferCount
        audioSpectrogram.hopCount = hopCount
        
        view.layer.addSublayer(audioSpectrogram)
        audioSpectrogram.startRunning()
    }

    override func viewDidLayoutSubviews() {
        audioSpectrogram.frame = view.frame
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        true
    }
    
    override var prefersStatusBarHidden: Bool {
        true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
