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

    @IBOutlet weak var exampleButton: UIButton!
    
    
    
    
    
    
    
    
    //@IBOutlet weak var spectrogramButton: UIButton!

    @IBOutlet weak var exampleText: UILabel!
    
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
    
    
    @IBAction func spectrogramSelected(_ sender: Any) {
        print(exampleButton.titleLabel)
        print("------------")
        print(exampleButton.currentTitle)
    }
    
    
    
}


