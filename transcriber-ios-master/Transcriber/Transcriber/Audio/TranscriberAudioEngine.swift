//
//  TranscriberAudioEngine.swift
//  TranscriberAudioEngine
//
//  Created by Daniel Kuntz on 8/23/21.
//

import Foundation
import AVFoundation

var sampleRate: Int {
    return 44_100
}

class TranscriberAudioEngine: NSObject {

    static let shared = TranscriberAudioEngine()

    // MARK: - Variables

    private let engine = AVAudioEngine()
    private let timePitch = AVAudioUnitTimePitch()
    let format = AVAudioFormat(standardFormatWithSampleRate: Double(sampleRate), channels: 2)

    fileprivate var fxProcessorL = EffectsProcessor()
    fileprivate var fxProcessorR = EffectsProcessor()
    private var semitones: Float = 0
    private var cents: Float = 0

    var playbackProgressCallback: ((_ progress: Float) -> Void)?
    var scrubbingPausedCallback: (() -> Void)?
    var fftVisualizationBufferCallback: ((_ buffer: [Float]) -> Void)?

    var sound: Sound? {
        didSet {
            soundPlayhead = 0
        }
    }

    var playing: Bool {
        return isPlaying
    }

    @objc class func sharedInstance() -> TranscriberAudioEngine {
        return TranscriberAudioEngine.shared
    }

    func start() {
        engine.attach(srcNode)
        engine.attach(timePitch)

        engine.connect(srcNode, to: timePitch, format: format)
        engine.connect(timePitch, to: engine.outputNode, format: format)

        do {
            try engine.start()
        } catch {
            print(error.localizedDescription)
        }

        // Configure AVAudioSession
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback,
                                                            mode: .default,
                                                            options: [.defaultToSpeaker,
                                                                      .allowAirPlay,
                                                                      .allowBluetoothA2DP,
                                                                      .mixWithOthers])
            let duration = 128 / Double(sampleRate)
            try AVAudioSession.sharedInstance().setPreferredIOBufferDuration(duration)
            try AVAudioSession.sharedInstance().setPreferredSampleRate(Double(sampleRate))
            try AVAudioSession.sharedInstance().setActive(true, options: [])
        } catch let error {
            print("Error starting AVAudioSession: \(error.localizedDescription)")
        }
    }

    func startPlaying() {
        if soundPlayhead == (sound?.bufferL.count ?? 0) {
            soundPlayhead = 0
        }
        isPlaying = true
    }

    func stopPlaying() {
        isPlaying = false
    }

    func setFilterFreqRange(_ range: ClosedRange<Float>) {
        fxProcessorL.setHighPassFreq(range.lowerBound)
        fxProcessorL.setLowPassFreq(range.upperBound)
        fxProcessorR.setHighPassFreq(range.lowerBound)
        fxProcessorR.setLowPassFreq(range.upperBound)
    }

    func setLoopProgressRange(_ range: ClosedRange<Float>) {
        guard let sound = sound else {
            return
        }

        let lowerSamp = Int(range.lowerBound * Float(sound.bufferL.count))
        let upperSamp = Int(range.upperBound * Float(sound.bufferL.count))
        loopRange = lowerSamp...upperSamp
    }

    func enableLooping() {
        loopingEnabled = true
    }

    func disableLooping() {
        loopingEnabled = false
    }

    func setPitchShift(_ semitones: Float, cents: Float) {
        let cents = (semitones * 100) + cents
        timePitch.pitch = cents
    }

    func setSpeed(_ speed: Double) {
        timePitch.rate = Float(speed)
    }

    func seek(offset: TimeInterval) {
        let sampleOffset = Int(round(offset * Double(sampleRate)))
        let bufferCount = sound?.bufferL.count ?? 1
        soundPlayhead = (soundPlayhead + sampleOffset).clamped(to: 0...(bufferCount-1))

        let progress = Float(soundPlayhead) / Float(bufferCount)
        playbackProgressCallback?(progress)
    }

    func scrub(toProgress progress: Float) {
        if isPlaying {
            stopPlaying()
            scrubbingPausedCallback?()
        }

        guard let sound = sound else {
            return
        }

        soundPlayhead = Int(progress * Float(sound.bufferL.count))
    }
}

private(set) var soundPlayhead: Int = 0
private(set) var loopRange: ClosedRange<Int>?
private(set) var loopingEnabled: Bool = false
private(set) var isPlaying: Bool = false

private let srcNode = AVAudioSourceNode { _, _, frameCount, audioBufferList -> OSStatus in
    let engine = TranscriberAudioEngine.shared

    let abl = UnsafeMutableAudioBufferListPointer(audioBufferList)
    let leftPointer: UnsafeMutableBufferPointer<Float32> = UnsafeMutableBufferPointer(abl[0])
    let rightPointer: UnsafeMutableBufferPointer<Float32> = UnsafeMutableBufferPointer(abl[1])
    let frameCountInt = Int(frameCount)

    guard let sound = engine.sound,
          soundPlayhead + 1 < sound.bufferL.count,
          isPlaying else {
              for i in 0..<frameCountInt {
                  leftPointer[i] = 0
                  rightPointer[i] = 0
              }
              return noErr
          }

    for i in 0..<frameCountInt {
        if soundPlayhead >= sound.bufferL.count {
            let progress = Float(soundPlayhead) / Float(sound.bufferL.count)
            engine.playbackProgressCallback?(progress)
            engine.scrubbingPausedCallback?()
            isPlaying = false
            return noErr
        }

        if loopingEnabled, let loopRange = loopRange, soundPlayhead > loopRange.upperBound {
            soundPlayhead = loopRange.lowerBound
        }

        let rawL = sound.bufferL[soundPlayhead]
        let rawR = sound.bufferR[soundPlayhead]

        let processedL = engine.fxProcessorL.processMono(rawL)
        let processedR = engine.fxProcessorR.processMono(rawR)

        leftPointer[i] = processedL
        rightPointer[i] = processedR

        soundPlayhead += 1
    }

    let progress = Float(soundPlayhead) / Float(sound.bufferL.count)
    engine.playbackProgressCallback?(progress)

    return noErr
}
