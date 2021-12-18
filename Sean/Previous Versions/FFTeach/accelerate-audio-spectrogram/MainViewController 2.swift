//
//  ContentView.swift
//  Shared
//
//  Created by Joseph Taylor on 10/8/21.
//

import AVFoundation
import Accelerate
import UIKit
import AVKit

class MainViewController: UIViewController {
    
    // Creates an audioSpectrogram object. This object will be made visible later by inserting it into a Sublayer. Note that you must add a "Privacy - Microphone Usage Description" entry to 'Info.plist' in order to allow the audioSpectrogram microphone access.
    var audioSpectrogram = AudioSpectrogram()
    // Creates label objects used to hold text. These objects will also be made visible later by being inserted into their own Sublayer
    // MORE LABEL OBJECTS WILL BE INSTANTIATED HERE WHEN MORE TEXT IS ADDED TO THE APP'S MAIN VIEW

    @IBOutlet weak var spectrogramContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioSpectrogram.contentsGravity = .resize
        spectrogramContainer.layer.addSublayer(audioSpectrogram)
        spectrogramContainer.backgroundColor = .black
        audioSpectrogram.startRunning()
    }
    
    override func viewDidLayoutSubviews() {
        audioSpectrogram.frame = spectrogramContainer.bounds
    }
    
    func set(sampleCount: Int) {
        audioSpectrogram.stopRunning()
        audioSpectrogram.removeFromSuperlayer()
        
        audioSpectrogram = AudioSpectrogram()
        audioSpectrogram.contentsGravity = .resize
        audioSpectrogram.sampleCount = sampleCount
        spectrogramContainer.layer.addSublayer(audioSpectrogram)
        audioSpectrogram.frame = spectrogramContainer.bounds
        audioSpectrogram.startRunning()
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        let values = [512, 1024, 2048, 4096]
        set(sampleCount: values[sender.selectedSegmentIndex])
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        true
    }
    
    override var prefersStatusBarHidden: Bool {
        true
    }

}
