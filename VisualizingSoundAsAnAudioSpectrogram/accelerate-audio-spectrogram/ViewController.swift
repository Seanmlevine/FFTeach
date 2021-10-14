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
import AVFoundation

class ViewController: UIViewController {
    
    // Creates an audioSpectrogram object. This object will be made visible later by inserting it into a Sublayer. Note that you must add a "Privacy - Microphone Usage Description" entry to 'Info.plist' in order to allow the audioSpectrogram microphone access.
    let audioSpectrogram = AudioSpectrogram()
    // Creates label objects used to hold text. These objects will also be made visible later by being inserted into their own Sublayers
    let label1 = UILabel()
    // MORE LABEL OBJECTS WILL BE INSTANTIATED HERE WHEN MORE TEXT IS ADDED TO THE APP'S MAIN VIEW
    
    // Gets the overall screen dimensions and stores them in the variable 'screenRect'. This variable is then called within the later functions, where it resizes the view of objects to the proper size by using measurements relative to the overall size of the device's screen.
    let screenRect = UIScreen.main.bounds
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Sets the background color of the view
        view.backgroundColor = .white
        // Sets the dimensions of the "label1" object
        label1.frame = CGRect(x: (screenRect.size.width / 2 - 100), y: (screenRect.size.height / 2 - 100), width: 200 , height: 200)
        // Sets the text to be stored within the "label1" object
        label1.text = "test test test test test test test test test test test test test test test test"
        
        //THIS PART IS IMPORTANT! These two lines of code make "label1" capable of containing multi-line text.
        label1.lineBreakMode = .byWordWrapping
        label1.numberOfLines = 0
        
        // Sets the background color of "label1"
        label1.backgroundColor = .lightGray
        // Sets the text color of "label1"
        label1.textColor = .blue
        // Sets the text allignment of "label1" to ".center", which aligns the text with respect to "label1"'s frame
        label1.textAlignment = .center
        // Inserts "label1" into its own Sublayer(Sublayer #1). This is where the object is actually added to the app's view.
        self.view.layer.insertSublayer(label1.layer, at: 1)
    }

    override func viewDidLayoutSubviews() {
        // Sets the dimensions of the audioSpectrogram. Notice that in order to set its dimensions relative to the overall size of the device's screen, the "ScreenRect" variable initialized earlier has to be used.
        audioSpectrogram.frame.origin.x = (screenRect.size.width * 0.1)
        audioSpectrogram.frame.origin.y = (screenRect.size.height * (1/22))
        audioSpectrogram.frame.size.width = (screenRect.size.width * 0.8)
        audioSpectrogram.frame.size.height = (screenRect.size.height * (7/22))
        // Inserts the audioSpectogram into its own Sublayer(Sublayer #0). This is where the object is actually added to the app's view.
        self.view.layer.insertSublayer(audioSpectrogram, at: 0)
        //Runs the audioSpectogram
        audioSpectrogram.startRunning()
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        true
    }
    
    override var prefersStatusBarHidden: Bool {
        true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Creates an AVPlayer object named "player" that holds the video "VideoEx.mov"
        let player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "VideoEx", ofType: "mov")!))
        //Creates a layer variable for the video to be stored within
        let videoLayer = AVPlayerLayer(player: player)
        // Sets the dimensions of "videoLayer"
        videoLayer.frame = view.bounds
        videoLayer.frame.origin.x = (screenRect.size.width * 0.1)
        videoLayer.frame.origin.y = (screenRect.size.height * (7/11))
        videoLayer.frame.size.width = (screenRect.size.width * 0.8)
        videoLayer.frame.size.height = (screenRect.size.height * (7/22))
        // Inserts "videoLayer" into its own Sublayer(Sublayer #2). This is where the object is actually added to the app's view.
        view.layer.insertSublayer(videoLayer, at: 2)
        //Automatically plays the video
        player.play()
    }
}
