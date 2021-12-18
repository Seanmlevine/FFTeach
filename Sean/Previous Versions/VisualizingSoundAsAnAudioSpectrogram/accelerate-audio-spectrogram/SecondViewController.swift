//
//  SecondViewController.swift
//  accelerate-audio-spectrogram
//
//  Created by Sean Levine on 10/20/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import AVFoundation
import Accelerate
import UIKit
import AVKit
import AVFoundation

class SecondViewController: UIViewController {

    //@IBOutlet weak var spectrogramButton: UIButton!

    override func viewDidLoad() {
    super.viewDidLoad()
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
}
