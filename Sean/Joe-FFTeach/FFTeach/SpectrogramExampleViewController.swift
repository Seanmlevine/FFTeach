//
//  SpectrogramExampleViewController.swift
//
//  Created by Sean Levine on 10/20/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Accelerate
import UIKit
import AVKit
import AVFoundation

class SpectrogramExampleViewController: UIViewController {

    @IBOutlet weak var videoContainer1: VideoContainer!
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var exampleText: UILabel!
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    var avPlayer: AVPlayer!
    
    var SnareText = String("Since the spectrogram above is utilized as a tool to visualize how a sound changes over time, the video above visualizes the auditory content produced by a typical snare drum. Firstly, notice the eight spikes presented within the spectrogram. The left side of the spike represents the attack whereas the right side of the spike represents the decay, sustain, and release related to the sound. However, since the hit of a snare drum makes a short, instantaneous sound, it has an extremely short decay and sustain, placing the emphasis of its sound in its attack and release. Therefore, the right side of each spike overwhelmingly represents the release portion of the sound. Although drums are commonly thought of as being ‘unpitched’, it is important to recognize that every sound has at least one pitched component. Furthermore, each sound has a fundamental frequency. Additionally, a snare hit does have harmonics, but the frequencies of its harmonics aren’t directly proportional to the fundamental frequency of each hit, which is uniquely different from instruments like a piano, trumpet, or guitar. This is to be expected since the pitch of a snare hit is difficult to distinguish, and as a result, drums are often described as being ‘atonal’ instruments.")
    var BassDrumText = String("The video above visualizes the auditory content produced by a bass drum. Like the snare drum, the hit of a bass drum makes a short, instantaneous sound, and it has an extremely short decay and sustain, placing the emphasis of its sound in its attack and release. Additionally, its frequency content is also ‘atonal’ due to its seemingly random harmonics, which are largely represented by the purple dots in the upper portion of each spike. Furthermore, since the y-axis of the spectrogram corresponds to frequency, the height of each bass drum spike is lower than the height of each snare drum spike. Naturally, this is due to the bass drum producing a lower, fundamental frequency than the snare drum.")
    var SineText = String("The video above visualizes the auditory content produced by an electronically produced sine wave. Since the sine wave visualized above was created by a computer, its fundamental frequency (440 Hz) and amplitude are unwavering. Furthermore, the purple lines representing the sine wave’s harmonics are clearly visible as well. Additionally, since the harmonics present are relatively weak, as visualized by their dark color, the timbre of the sine wave is smooth and subdued, which makes it sound much different than a square wave.")
    var SquareText = String("The video above visualizes the auditory content produced by an electronically produced square wave. Like the sine wave, the square wave visualized above was created by a computer, and its fundamental frequency (440 Hz) and amplitude are also unwavering. However, unlike the sine wave example, the lines representing the square wave’s harmonics are much more light and bright in their color. Since these harmonics are visually bright, their amplitudes are almost as high as the amplitude of the fundamental frequency. As a result, the timbre of the square wave is harsh and bright, which makes it sound much different than a sine wave.")
    var PianoText = String("The video above visualizes the auditory content produced by notes played on a piano. As the pitch of the piano notes being played ascends, the spectrogram creates content that is similar to an ascending staircase in appearance. Additionally, since the yellow content corresponds to the fundamental frequency of each note, the rising groups of yellow spectra also correspond to the rising pitch of each piano note. Furthermore, notice the repetitive lines of purple spectra over each group of yellow spectra. Each purple line represents a harmonic of the fundamental frequency. Unlike those produced by drums, the harmonics produced by a piano are integer multiples of the fundamental frequency. This explains why each of the purple lines is spaced at regular intervals.")
    var SongFileText = String("The video above visualizes the auditory content produced by the Georgia Tech Fight Song. Unlike the other examples, this song includes audio from numerous instruments over a wide range of frequencies and intensities. Although the lower portion of the frequency range is dominated by brass sounds, sounds produced by the percussion section can be clearly seen within the spectrogram due to the large spikes in spectra produced by each drum hit. Additionally, the sounds produced by the cymbals also dominate the upper register of the frequency range. Although the vocal chants at the end of the video are not exactly distinguishable visibly, the sound produced by the drum major's whistle, as well as its harmonics, at the beginning of the example can be clearly seen.")
    var NoiseText = String("The video above visualizes the auditory content produced by white noise. Since the sound of white noise is largely uniform across all frequencies, there are no yellow groups of spectra produced within the spectrogram above since the fundamental frequency of the sound is indistinguishable. Additionally, white noise is described as having a “flat spectral density”, which means the sound produced is filled with frequencies across the range of human hearing (20 - 20,000 Hz), and all of these frequencies are played with a constant amplitude. As a result, the envelope of the white noise visualized within the example above is characterized with a long and constant sustain.")
    
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
        
        let values = ["SnareSpec", "BassDrumSpec", "SineWaveSpec", "SquareWaveSpec", "PianoSpec", "SongFileSpec", "NoiseSpec"]
        videoContainer1.playVideo(withName: values[0])
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
    
    @IBAction func exampleValueChanged(_ sender: UISegmentedControl) {
        let values = ["SnareSpec", "BassDrumSpec", "SineWaveSpec", "SquareWaveSpec", "PianoSpec", "SongFileSpec", "NoiseSpec"]
        videoContainer1.stopVideo(withName: values[0])
        let textValues = [self.SnareText, self.BassDrumText, self.SineText, self.SquareText, self.PianoText, self.SongFileText, self.NoiseText]
        let titles = ["Snare Drum", "Bass Drum", "Sine Wave", "Square Wave", "Piano Scale", "GT Fight Song", "White Noise"]
        videoContainer1.playVideo(withName: values[sender.selectedSegmentIndex])
        self.exampleText.text = textValues[sender.selectedSegmentIndex]
        self.titleText.text = titles[sender.selectedSegmentIndex]
    }
}
