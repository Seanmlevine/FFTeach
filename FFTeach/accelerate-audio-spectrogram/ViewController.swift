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

class ViewController: UIViewController {
    
    // Creates an audioSpectrogram object. This object will be made visible later by inserting it into a Sublayer. Note that you must add a "Privacy - Microphone Usage Description" entry to 'Info.plist' in order to allow the audioSpectrogram microphone access.
    let audioSpectrogram = AudioSpectrogram()
    // Creates label objects used to hold text. These objects will also be made visible later by being inserted into their own Sublayer
    // MORE LABEL OBJECTS WILL BE INSTANTIATED HERE WHEN MORE TEXT IS ADDED TO THE APP'S MAIN VIEW

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        // Sets the dimensions of the audioSpectrogram. Notice that in order to set its dimensions relative to the overall size of the device's screen, the "ScreenRect" variable initialized earlier has to be used.
        /* audioSpectrogram.frame.origin.x = (screenRect.size.width * 0.1)
        audioSpectrogram.frame.origin.y = (screenRect.size.height * (1/22))
        audioSpectrogram.frame.size.width = (screenRect.size.width * 0.8)
        audioSpectrogram.frame.size.height = (screenRect.size.height * (7/22))
        // Inserts the audioSpectogram into its own Sublayer(Sublayer #0). This is where the object is actually added to the app's view.
        self.view.layer.insertSublayer(audioSpectrogram, at: 0)*/
        //Runs the audioSpectogram
        audioSpectrogram.startRunning()
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        true
    }
    
    override var prefersStatusBarHidden: Bool {
        true
    }

}
