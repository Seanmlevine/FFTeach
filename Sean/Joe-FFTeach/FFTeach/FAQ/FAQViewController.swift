//
//  FAQViewController.swift
//  FFTeach
//
//  Created by Sean Levine on 12/3/21.
//

import UIKit

class FAQViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path1 = "https://github.com/Seanmlevine/FFTeach"
        let text1 = "All of our code for FFTeach, as well as the video examples found within it, can be found on our GitHub repository here!"
        let attributedString1 = NSAttributedString.makeHyperlink(for: path1, in: text1, as: "All of our code for FFTeach, as well as the video examples found within it, can be found on our GitHub repository here!")
        
        let path2 = "https://www.izotope.com/en/learn/understanding-spectrograms.html"
        let text2 = "Click here to learn more in-depth information about spectrograms from izotope.com!"
        let attributedString2 = NSAttributedString.makeHyperlink(for: path2, in: text2, as: "Click here to learn more in-depth information about spectrograms from izotope.com!")
        
        let path3 = "http://www.avisoft.com/tutorials/selecting-appropriate-spectrogram-parameters/"
        let text3 = "To learn more, click here!"
        let attributedString3 = NSAttributedString.makeHyperlink(for: path3, in: text3, as: "To learn more, click here!")
        
        let path4 = "https://pulsarinstruments.com/en/post/understanding-a-c-z-noise-frequency-weightings"
        let text4 = "Click here!"
        let attributedString4 = NSAttributedString.makeHyperlink(for: path4, in: text4, as: "Click here!")
        
        let items = [FAQItem(question: "Glossary", answer: "Decibel - the unit used to describe the loudness of a sound.\n \nFrequency - the rate at which a wave is repeated in a specified amount.\n \nFundamental Frequency - the lowest frequency resonated.\n \nHarmonics - an overtone accompanying a fundamental tone at a fixed interval, meaning it is an integer multiple of the fundamental. Multiple harmonics comprise a harmonic series./n /nHertz - the unit of measure for frequency. 1 Hertz(Hz) is one wave cycle per second.\n \nOvertone - a tone apart of the harmonic series found above the fundamental. Although overtones are not immediately recognizable, they change what is called the timbre of a sound."), FAQItem(question: "Where can I find your code?", attributedAnswer: attributedString1), FAQItem(question: "Want to learn more about Spectrograms?", attributedAnswer: attributedString2), FAQItem(question: "Want to learn more about the frame size of a spectrogram?", attributedAnswer: attributedString3), FAQItem(question: "Want to learn more about different frequency weightings?", attributedAnswer: attributedString4)
        ]
        
        let faqView = FAQView(frame: view.frame, title: "FAQs", items: items)
        view.addSubview(faqView)
        // Do any additional setup after loading the view.
    }
}
