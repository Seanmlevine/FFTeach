//
//  FreqExampleViewController.swift
//
//  Created by Sean Levine on 10/20/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Accelerate
import UIKit
import AVKit
import AVFoundation

class FreqExampleViewController: UIViewController {

    @IBOutlet weak var videoContainer2: VideoContainer!
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var exampleText: UILabel!
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    var avPlayer2: AVPlayer!
    
    var SnareText = String("Since the spectrum analyzer above is utilized as a tool to visualize the intensity of sound over a range of frequencies in real-time, the video above visualizes the auditory content produced by a typical snare drum. Firstly, since a drum hit only makes a short and instantaneous sound, the frequency response shown above only showcases data for short moments as well. Although drums are commonly thought of as being ‘unpitched’, it is important to recognize that every sound has at least one pitched component. Furthermore, each sound has a fundamental frequency. Additionally, a snare hit does have harmonics, but the frequencies of its harmonics aren’t directly proportional to the fundamental frequency of each hit, which is uniquely different from instruments like a piano, trumpet, or guitar. This is to be expected since the pitch of a snare hit is difficult to distinguish, and as a result, drums are often described as being ‘atonal’ instruments.")
    var BassDrumText = String("The video above visualizes the auditory content produced by a bass drum. Like the snare drum, the hit of a bass drum makes a short, instantaneous sound, and therefore, its data is only shown for brief moments. Additionally, its frequency content is also ‘atonal’ due to its seemingly random harmonics, which are represented by the spectral spikes on the right side of the video. Furthermore, since the y-axis of the spectrum analyzer corresponds to amplitude, the height of the harmonics are shorter than the height of the bass drum's fundamental frequency. This also makes the data slope downwards from left to right as the x-axis increases in frequency.")
    var SineText = String("The video above visualizes the auditory content produced by an electronically produced sine wave. The sine wave visualized above was created by a computer, and the amplitude of its fundamental frequency (440 Hz) can be slearly seen wihin the video on the left. Additionally, since the harmonics, occuring below 5kHz, are relatively weak in amplitude, which can be seen by their short spikes, the timbre of the sine wave is smooth and subdued, which makes it sound much different than a square wave.")
    var SquareText = String("The video above visualizes the auditory content produced by an electronically produced square wave. Like the sine wave, the square wave visualized above was created by a computer, and its fundamental frequency (440 Hz) and amplitude are also unwavering. However, unlike the sine wave example, the spikes representing the square wave’s harmonics are much taller and occur over a much wider range of frequencies. Unlike the sine wave, these harmonics are present across the x-axis all the way up to 20kHz. Since these harmonic spikes are almost as tall as the spike of the fundamental frequency on the left side of the video, the harmonic amplitudes are almost as high as the amplitude of the fundamental frequency. As a result, the timbre of the square wave is harsh and bright, which makes it sound much different than a sine wave.")
    var PianoText = String("The video above visualizes the auditory content produced by notes played on a piano. However, as the pitch of the piano notes being played ascends, the spectrum analyzer doesn't change nearly as much in appearance as a spectrogram does. Despite this, the spikes in amplitude can be clearly seen shifting along the x-axis, which corresponds to the shift in pitch of each note. Unlike those produced by drums, the harmonics produced by a piano are integer multiples of the fundamental frequency. This explains why each of the spikes in amplitude are spaced along the frequency axis at regular intervals.")
    var SongFileText = String("The video above visualizes the auditory content produced by the Georgia Tech Fight Song. Unlike the other examples, this song includes audio from numerous instruments over a wide range of frequencies and intensities. Although the lower portion of the frequency range is dominated by brass sounds, sounds produced by the percussion section can be clearly seen within the spectrum analyzer since percussion instruments produce sounds across a wide range of frequencies up to 20kHz. Additionally, the sounds produced by the cymbals also dominate the upper register of the frequency range. Although the vocal chants at the end of the video are not exactly distinguishable visibly, the sound produced by the drum major's whistle, as well as its harmonics, at the beginning of the example can be clearly seen.")
    var NoiseText = String("The video above visualizes the auditory content produced by white noise. Since the sound of white noise is largely uniform across all frequencies, the spikes in amplitude produced within the spectrum analyzer above stay virtually flat across the entire x-axis. Since white noise is described as having a “flat spectral density”, the sound produced is filled with frequencies across the range of human hearing (20 - 20,000 Hz), and all of these frequencies are played with a constant amplitude. As a result, unlike other examples, the frequency response of white noise remains predominately flat.")
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidLoad() {
    super.viewDidLoad()
        
        textView.backgroundColor = UIColor.systemGray5
        
        // Sets the text to be stored within the "spectrogramText" object
        exampleText.text = "Since the spectrogram above is utilized as a tool to visualize how a sound changes over time, the video above visualizes the auditory content produced by a typical snare drum. Firstly, notice the eight spikes presented within the spectrogram. The left side of the spike represents the attack whereas the right side of the spike represents the decay, sustain, and release related to the sound. However, since the hit of a snare drum makes a short, instantaneous sound, it has an extremely short decay and sustain, placing the emphasis of its sound in its attack and release. Therefore, the right side of each spike overwhelmingly represents the release portion of the sound. Although drums are commonly thought of as being ‘unpitched’, it is important to recognize that every sound has at least one pitched component. Furthermore, each sound has a fundamental frequency. Additionally, a snare hit does have harmonics, but the frequencies of its harmonics aren’t directly proportional to the fundamental frequency of each hit, which is uniquely different from instruments like a piano, trumpet, or guitar. This is to be expected since the pitch of a snare hit is difficult to distinguish, and as a result, drums are often described as being ‘atonal’ instruments."
        
        //THIS PART IS IMPORTANT! These two lines of code make "label1" capable of containing multi-line text.
        exampleText.lineBreakMode = .byWordWrapping
        exampleText.numberOfLines = 0
        
        // Sets the background color of "label1"
        exampleText.backgroundColor = .black
        //Sets the text color of "spectrogramText"
        exampleText.textColor = .white
        // Centers "spectrogramText" horizontally within the view
        exampleText.textAlignment = .center
        
        let values = ["SnareFreq", "BassDrumFreq", "SineWaveFreq", "SquareWaveFreq", "PianoFreq", "SongFileFreq", "NoiseFreq"]
        videoContainer2.playVideo(withName: values[0])
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
        
        let values = ["SnareFreq", "BassDrumFreq", "SineWaveFreq", "SquareWaveFreq", "PianoFreq", "SongFileFreq", "NoiseFreq"]
        videoContainer2.stopVideo(withName: values[0])
        let textValues = [self.SnareText, self.BassDrumText, self.SineText, self.SquareText, self.PianoText, self.SongFileText, self.NoiseText]
        let titles = ["Snare Drum", "Bass Drum", "Sine Wave", "Square Wave", "Piano Scale", "GT Fight Song", "White Noise"]
        videoContainer2.playVideo(withName: values[sender.selectedSegmentIndex])
        self.exampleText.text = textValues[sender.selectedSegmentIndex]
        self.titleText.text = titles[sender.selectedSegmentIndex]
    }
}


