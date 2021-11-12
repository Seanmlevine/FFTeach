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
    
    // Axis Label and the Min and Max values of the Spectrogram initiated and connected to storyboard
    @IBOutlet weak var yaxisLabel: UILabel!
    @IBOutlet weak var zeroHzLabel: UILabel!
    @IBOutlet weak var twentykHzLabel: UILabel!
    
    @IBOutlet weak var spectralViewButton: UIButton!
    
    @IBOutlet weak var spectrogramContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change the Size of the Spectrogram, add to super, change the color, and run when view loads
        audioSpectrogram.contentsGravity = .resize
        spectrogramContainer.layer.addSublayer(audioSpectrogram)
        spectrogramContainer.backgroundColor = .black
        audioSpectrogram.startRunning()
        
        
        // Initialize Text for Labels and rotate 270 degrees
        zeroHzLabel.text = "0 Hz"
        twentykHzLabel.text = "20 kHz"
        yaxisLabel.text = "FREQUENCY"
        
        zeroHzLabel.transform = CGAffineTransform(rotationAngle: (3.14159/2)*3)
        
        twentykHzLabel.transform = CGAffineTransform(rotationAngle: (3.14159/2)*3)
        
        yaxisLabel.transform = CGAffineTransform(rotationAngle: (3.14159/2)*3)
    }
    
    // When subviews are created, make the spectrogramContainer the proper size from storyboard
    override func viewDidLayoutSubviews() {
        audioSpectrogram.frame = spectrogramContainer.bounds
    }
    
    // Function to allow the spectrogram to restart if segmented control is altered
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
    
    // Change of sample count, options shown and calls the restart of the spectrogram
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        let values = [512, 1024, 2048, 4096]
        set(sampleCount: values[sender.selectedSegmentIndex])
    }
    
    // If the view is no longer this controller, stop the spectrogram
    override func viewDidDisappear(_ animated: Bool) {
        audioSpectrogram.stopRunning()
    }
    
    // If the view returns, start the spectrogram again
    override func viewDidAppear(_ animated: Bool) {
        audioSpectrogram.startRunning()
    }
    
    @IBAction func spectralViewButtonPressed(_ sender: UIButton) {
        audioSpectrogram.stopRunning()
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        true
    }
    
    override var prefersStatusBarHidden: Bool {
        true
    }

}
