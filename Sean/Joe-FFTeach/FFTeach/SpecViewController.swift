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

class SpecViewController: UIViewController {
    
    // Creates an audioSpectrogram object. This object will be made visible later by inserting it into a Sublayer. Note that you must add a "Privacy - Microphone Usage Description" entry to 'Info.plist' in order to allow the audioSpectrogram microphone access.
    var audioSpectrogram = AudioSpectrogram()
    
    
    @IBOutlet weak var spectrogramText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioSpectrogram.contentsGravity = .resize
        view.layer.addSublayer(audioSpectrogram)
  
        view.backgroundColor = .black
        audioSpectrogram.startRunning()
        
        
        // Sets the text to be stored within the "spectrogramText" object
        spectrogramText.text = "This is the text that will go in the label below the Spectrogram. This should be able to currently hold up to 25 lines of text. If it needs to hold more, just let me know."
        
        //THIS PART IS IMPORTANT! These two lines of code make "label1" capable of containing multi-line text.
        spectrogramText.lineBreakMode = .byWordWrapping
        spectrogramText.numberOfLines = 0
        
        // Sets the background color of "label1"
        //spectrogramText.backgroundColor = .black
        //Sets the text color of "spectrogramText"
        spectrogramText.textColor = .white
        // Centers "spectrogramText" horizontally within the view
        spectrogramText.textAlignment = .center
    }

    @IBOutlet weak var spectrogramContainer: UIView!
    override func viewDidLayoutSubviews() {
        audioSpectrogram.frame = spectrogramContainer.bounds
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
    
    
}
