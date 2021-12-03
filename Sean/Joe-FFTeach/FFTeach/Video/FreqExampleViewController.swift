//
//  SpectrogramExampleViewController.swift
//
//  Created by Sean Levine on 10/20/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Accelerate
import UIKit
import AVKit
import AVFoundation

class FreqExampleViewController: UIViewController {

    @IBOutlet weak var videoContainer: VideoContainer!
    @IBOutlet weak var exampleText: UILabel!
    
    var avPlayer: AVPlayer!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let videoNames = ["BassDrumFreq", "SineWaveFreq", "SnareFreq", "SquareWaveFreq", "PianoFreq"]
        videoContainer.playVideo(withName: videoNames[0])
    }
    
    override func viewDidLoad() {
    super.viewDidLoad()
        // Sets the text to be stored within the "spectrogramText" object
        exampleText.text = "This is the text that will go in the label below the Spectrogram. This should be able to currently hold up to 25 lines of text. If it needs to hold more, just let me know."
        
        //THIS PART IS IMPORTANT! These two lines of code make "label1" capable of containing multi-line text.
        exampleText.lineBreakMode = .byWordWrapping
        exampleText.numberOfLines = 0
        
        // Sets the background color of "label1"
        //exampleText.backgroundColor = .black
        //Sets the text color of "spectrogramText"
        exampleText.textColor = .white
        // Centers "spectrogramText" horizontally within the view
        exampleText.textAlignment = .center
        
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        true
    }

    override var prefersStatusBarHidden: Bool {
        true
    }
    @IBAction func dropDownChanged(_ sender: UIMenuElement) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func exampleValueChanged(_ sender: UISegmentedControl) {
        let values = ["BassDrumFreq", "SineWaveFreq", "PianoFreq", "SnareFreq", "SquareWaveFreq"]
        videoContainer.playVideo(withName: values[sender.selectedSegmentIndex])
    }
    
    
}

