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
    
    @IBOutlet weak var spectrogramText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
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

    override func viewDidLayoutSubviews() {
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

