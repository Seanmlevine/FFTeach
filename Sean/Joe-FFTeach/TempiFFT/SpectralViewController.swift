//
//  SpectralViewController.swift
//
//  Created by Sean Levine on 11/22/2021.
//  Copyright © 2021 Sean Levine. All rights reserved.
//

import UIKit
import AVFoundation

class SpectralViewController: UIViewController {
    
    @IBOutlet weak var spectralView: SpectralView!
    
    var audioInput: TempiAudioInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let audioInputCallback: TempiAudioInputCallback = { (timeStamp, numberOfFrames, samples) -> Void in
            self.gotSomeAudio(timeStamp: Double(timeStamp), numberOfFrames: Int(numberOfFrames), samples: samples)
        }
        
        audioInput = TempiAudioInput(audioInputCallback: audioInputCallback, sampleRate: 44100, numberOfChannels: 1)
        audioInput.startRecording()
    }

    func gotSomeAudio(timeStamp: Double, numberOfFrames: Int, samples: [Float]) {
        // NB: The default buffer size on iOS is 512. This will not give a terribly high resolution. In practice you'll want to bucket up the buffers into a larger array of at least size 2048.
        let fft = TempiFFT(withSize: 1024, sampleRate: 44100.0)
        fft.windowType = TempiFFTWindowType.hanning
        fft.fftForward(samples)
        
        // Interpoloate the FFT data so there's one band per pixel.
        let screenWidth = UIScreen.main.bounds.size.width * UIScreen.main.scale
        
        // NB: The UI in this demo app is geared towards a linear calculation. If you instead use calculateLogarithmicBands, the labels will not be placed correctly.
        fft.calculateLinearBands(minFrequency: 0, maxFrequency: fft.nyquistFrequency, numberOfBands: Int(screenWidth))

        tempi_dispatch_main { () -> () in
            self.spectralView.fft = fft
            self.spectralView.setNeedsDisplay()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        audioInput.startRecording()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        audioInput.stopRecording()
    }
    
    override func didReceiveMemoryWarning() {
        NSLog("*** Memory!")
        super.didReceiveMemoryWarning()
    }
}

