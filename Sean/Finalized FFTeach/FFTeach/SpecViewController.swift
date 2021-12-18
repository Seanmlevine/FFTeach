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
    
    @IBOutlet weak var spectrogramContainer: UIView!
    @IBOutlet weak var spectrogramText: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioSpectrogram.contentsGravity = .resize
        spectrogramContainer.layer.addSublayer(audioSpectrogram)
        spectrogramContainer.backgroundColor = .black
        audioSpectrogram.startRunning()
        
        let zeroHzLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        zeroHzLabel.center = CGPoint(x: spectrogramContainer.frame.minX+6, y: spectrogramContainer.frame.maxY + 20)
        
        zeroHzLabel.textAlignment = .center
        zeroHzLabel.text = "0 Hz"
        zeroHzLabel.transform = CGAffineTransform(rotationAngle: (3.14159/2)*3)
        zeroHzLabel.font = zeroHzLabel.font.withSize(9)
        
        let twentykHzLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        twentykHzLabel.center = CGPoint(x: spectrogramContainer.frame.minX+6, y: spectrogramContainer.frame.minY + 110)
        
        twentykHzLabel.textAlignment = .center
        twentykHzLabel.text = "20 kHz"
        twentykHzLabel.transform = CGAffineTransform(rotationAngle: (3.14159/2)*3)
        twentykHzLabel.font = zeroHzLabel.font.withSize(9)
        
        let yaxisLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        yaxisLabel.center = CGPoint(x: spectrogramContainer.frame.minX+6, y: spectrogramContainer.frame.midY + 68)
        
        yaxisLabel.textAlignment = .center
        yaxisLabel.text = "FREQUENCY (Hz)"
        yaxisLabel.transform = CGAffineTransform(rotationAngle: (3.14159/2)*3)
        yaxisLabel.font = zeroHzLabel.font.withSize(9)
    
        self.view.addSubview(zeroHzLabel)
        self.view.addSubview(twentykHzLabel)
        self.view.addSubview(yaxisLabel)
        
        spectrogramText.text = "Above is a spectrogram capturing real time audio! The content of the graph moves left to right with the newest content appearing on the right side of the screen. The spectrogram has the Y-Axis representing frequency ranging from 0 Hz to 20 kHz. There is also 4 different numbers representing FRAME SIZE. FRAME SIZE in a simple aspect, changes the spectrogram resolution. The bigger the frame size, the less clear the graph becomes."
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
        audioSpectrogram.startRunning()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        audioSpectrogram.stopRunning()
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
