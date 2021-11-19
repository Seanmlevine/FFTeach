//
//  SecondViewController.swift
//  accelerate-audio-spectrogram
//
//  Created by Sean Levine on 10/20/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Accelerate
import UIKit
import AVKit
import AVFoundation

class SpectrogramExampleViewController: UIViewController {

    @IBOutlet weak var exampleDropDown: UIButton!
    @IBOutlet weak var videoContainer: VideoContainer!
    @IBOutlet weak var exampleText: UILabel!
    
    var avPlayer: AVPlayer!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let videoNames = ["Bass Drum", "Noise", "Snare", "Square Wave", "Piano Scale", "Song File"]
        videoContainer.playVideo(withName: videoNames[1])
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
        

        //exampleButton.menu.addItems(withTitles: "Bass Drum", "Noise", "Snare", "Square Wave", "Piano Scale", "Song File")
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
    
    /*
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
     */
/*
    var buttonBoolean = false
    //@IBAction func spectrogramButtonPressed(_ sender: Any) {
        if buttonBoolean == false {
            spectrogramButton.setTitle("Stop Spectrogram", for: .normal)
            buttonBoolean = true
            //Starts the spectrogram
            audioSpectrogram.startRunning()
        } else {
            spectrogramButton.setTitle("Start Spectrogram", for: .normal)
            buttonBoolean = false
            //Stops the spectrogram
        }
    }
*/
    
    @IBOutlet weak var DropDown: UIMenu!
    
    
}


