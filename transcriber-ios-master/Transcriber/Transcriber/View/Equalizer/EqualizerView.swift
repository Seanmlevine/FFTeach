//
//  EqualizerView.swift
//  EqualizerView
//
//  Created by Daniel Kuntz on 8/15/21.
//

import UIKit
import PureLayout

protocol EqualizerViewDelegate: AnyObject {
    func trimmed(to freqRange: ClosedRange<Float>)
}

class EqualizerView: UIView {
    var sound: Sound? {
        didSet {
            spectrumView.sound = sound
        }
    }
    
    var time: TimeInterval = 0 {
        didSet {
            spectrumView.time = time
        }
    }

    weak var delegate: EqualizerViewDelegate?

    private var spectrumView: SpectrumView!
    private var trimView: TrimView!

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .clear

        spectrumView = SpectrumView()
        addSubview(spectrumView)
        spectrumView.autoPinEdgesToSuperviewEdges()

        trimView = TrimView()
        trimView.delegate = self
        trimView.color = UIColor(hex: "FE463A")
        trimView.trimViewBgColor = trimView.color.withAlphaComponent(0.1)
        trimView.handleColor = .white
        addSubview(trimView)
        trimView.autoPinEdgesToSuperviewEdges()
    }
}

extension EqualizerView: TrimViewDelegate {
    func trimmed(to progressRange: ClosedRange<Float>) {
        let maxLog: Float = log10(20000.0 / 10.0)
        let lowerFreq = 10 * powf(10, maxLog * progressRange.lowerBound)
        let upperFreq = 10 * powf(10, maxLog * progressRange.upperBound)
        let freqRange = lowerFreq...upperFreq
        delegate?.trimmed(to: freqRange)
    }
}
