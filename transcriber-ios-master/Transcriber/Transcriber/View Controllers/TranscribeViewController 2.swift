//
//  TranscribeViewController.swift
//  Transcriber
//
//  Created by Daniel Kuntz on 8/11/21.
//

import UIKit
import UniformTypeIdentifiers
import PhotosUI
import MobileCoreServices

class TranscribeViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var videoSwitcherButton: UIBarButtonItem!
    @IBOutlet weak var waveformGroupView: WaveformGroupView!
    @IBOutlet weak var loopMoveButton: ScalingPressButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var playButton: ScalingPressButton!
    @IBOutlet weak var eqContainer: UIView!
    @IBOutlet weak var equalizer: EqualizerView!
    @IBOutlet weak var sliderContainer: UIStackView!
    @IBOutlet weak var centsPicker: VerticalPicker!
    @IBOutlet weak var semitonesPicker: VerticalPicker!
    @IBOutlet weak var speedPicker: VerticalPicker!
    @IBOutlet weak var videoScrollView: UIScrollView!
    @IBOutlet weak var videoView: UIView!

    private var player: AVPlayer?
    private(set) var playerLayer: AVPlayerLayer?

    private var videoViewVisible: Bool = true
    private var sound: Sound?
    private var isLooping: Bool = false
    private var feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    private var seeking: Bool = false
    
    // MARK: - Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func setup() {
        videoScrollView.delegate = self
        videoScrollView.showsVerticalScrollIndicator = false
        videoScrollView.showsHorizontalScrollIndicator = false

        waveformGroupView.delegate = self
        equalizer.delegate = self

        centsPicker.setRange(-50...50, stride: 1)
        centsPicker.delegate = self
        semitonesPicker.setRange(-12...12, stride: 1)
        semitonesPicker.delegate = self
        speedPicker.setRange(0.2...1.5, stride: 0.1, centerValue: 1, decimals: 2, suffix: "x")
        speedPicker.delegate = self

        TranscriberAudioEngine.shared.playbackProgressCallback = { progress in
            DispatchQueue.main.async {
                self.waveformGroupView.scrub(toProgress: progress)
            }
        }

        TranscriberAudioEngine.shared.scrubbingPausedCallback = {
            DispatchQueue.main.async {
                UIView.transition(with: self.playButton, duration: 0.3, options: [.transitionFlipFromLeft], animations: {
                    self.playButton.setImage(UIImage(named: "glyph_play"), for: .normal)
                }, completion: nil)
            }
        }

        TranscriberAudioEngine.shared.start()
    }

    private func loadAudio(atUrl url: URL) {
        title = url.lastPathComponent
        sound = Sound(fileUrl: url)
        waveformGroupView.render(sound!)
        equalizer.sound = sound
        TranscriberAudioEngine.shared.sound = sound
        waveformGroupView.scrub(toProgress: 0)
    }

    private func loadVideo(atUrl url: URL) {
        player = AVPlayer(url: url)
        playerLayer?.removeFromSuperlayer()
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = videoView.bounds
        playerLayer?.videoGravity = .resizeAspect
        videoView.layer.addSublayer(playerLayer!)

        videoScrollView.minimumZoomScale = 1
        videoScrollView.maximumZoomScale = 7
    }
    
    @IBAction func loopTapped(_ sender: UIButton) {
        if isLooping {
            waveformGroupView.hideTrimView()
            sender.setImage(UIImage(named: "glyph_loop"), for: .normal)
            TranscriberAudioEngine.shared.disableLooping()
            loopMoveButton.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.2) {
                self.loopMoveButton.alpha = 0.4
            }
        } else {
            waveformGroupView.showTrimView()
            sender.setImage(UIImage(named: "glyph_loop_filled"), for: .normal)
            TranscriberAudioEngine.shared.enableLooping()
            loopMoveButton.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.2) {
                self.loopMoveButton.alpha = 1
            }
        }
        feedbackGenerator.impactOccurred()
        isLooping = !isLooping
    }

    @IBAction func videoSwitchTapped(_ sender: Any) {
        videoViewVisible = !videoViewVisible

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.1, options: [.curveEaseInOut, .beginFromCurrentState], animations: {
            self.videoScrollView.isHidden = !self.videoViewVisible
            self.videoScrollView.alpha = self.videoViewVisible ? 1 : 0
            self.eqContainer.isHidden = self.videoViewVisible
            self.eqContainer.alpha = self.videoViewVisible ? 0 : 1
            self.sliderContainer.isHidden = self.videoViewVisible
            self.sliderContainer.alpha = self.videoViewVisible ? 0 : 1
            self.view.layoutIfNeeded()
        }, completion: nil)

        UIView.transition(with: self.navigationController!.navigationBar,
                          duration: 0.2,
                          options: [.transitionCrossDissolve, .allowUserInteraction],
                          animations: {
            self.videoSwitcherButton.image = self.videoViewVisible ? UIImage(named: "glyph_video") : UIImage(named: "glyph_audio")
        }, completion: nil)
    }

    @IBAction func loopMoveTapped(_ sender: Any) {
        waveformGroupView.moveTrimToCurrentFrame()
        feedbackGenerator.impactOccurred()
    }

    @IBAction func addTapped(_ sender: Any) {
        if TranscriberAudioEngine.shared.playing {
            playPauseTapped(playButton)
        }

        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Choose File", style: .default, handler: { (_) in
            self.showFilePicker()
        }))

        alert.addAction(UIAlertAction(title: "Choose Video", style: .default, handler: { (_) in
            self.showVideoPicker()
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    private func showFilePicker() {
        let filetypes = [UTType("public.audio")!]
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: filetypes, asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        documentPicker.shouldShowFileExtensions = true
        present(documentPicker, animated: true, completion: nil)
    }

    private func showVideoPicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [String(kUTTypeMovie)]
        picker.videoExportPreset = AVAssetExportPresetPassthrough
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }

    @IBAction func playPauseTapped(_ sender: UIButton) {
        if TranscriberAudioEngine.shared.playing {
            TranscriberAudioEngine.shared.stopPlaying()
            UIView.transition(with: sender, duration: 0.3, options: [.transitionFlipFromLeft], animations: {
                sender.setImage(UIImage(named: "glyph_play"), for: .normal)
            }, completion: nil)
        } else {
            TranscriberAudioEngine.shared.startPlaying()
            UIView.transition(with: sender, duration: 0.3, options: [.transitionFlipFromLeft], animations: {
                sender.setImage(UIImage(named: "glyph_pause"), for: .normal)
            }, completion: nil)
        }
        feedbackGenerator.impactOccurred()
    }

    @IBAction func ffTapped(_ sender: Any) {
        TranscriberAudioEngine.shared.seek(offset: 1)
        feedbackGenerator.impactOccurred()
    }

    @IBAction func rwTapped(_ sender: Any) {
        TranscriberAudioEngine.shared.seek(offset: -1)
        feedbackGenerator.impactOccurred()
    }
    
    @IBAction func flagTapped(_ sender: Any) {
        waveformGroupView.addFlag()
    }
}

extension TranscribeViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return videoView
    }
}

extension TranscribeViewController: UIDocumentPickerDelegate {
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard !urls.isEmpty else {
            return
        }

        loadAudio(atUrl: urls[0])
    }
}

extension TranscribeViewController: WaveformGroupDelegate {
    func didScroll(toTime time: TimeInterval, userInitiated: Bool) {
        let minutes = Int(time / 60)
        let seconds = Int(time.truncatingRemainder(dividingBy: 60))
        let milliseconds = Int((time - floor(time)) * 100)
        timeLabel.text = ((minutes < 10) ? "0" : "") + "\(minutes)" + ":" +
                         ((seconds < 10) ? "0" : "") + "\(seconds)" + "." +
                         ((milliseconds < 10) ? "0" : "") + "\(milliseconds)"

        equalizer.time = time

        if let sound = sound, userInitiated {
            let durationFraction = Float(time / sound.duration)
            TranscriberAudioEngine.shared.scrub(toProgress: durationFraction)
        }

        let cmTime = CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player?.seek(to: cmTime, toleranceBefore: .zero, toleranceAfter: .zero)
    }

    func didSetLoopRange(to range: ClosedRange<Float>) {
        TranscriberAudioEngine.shared.setLoopProgressRange(range)
    }
}

extension TranscribeViewController: EqualizerViewDelegate {
    func trimmed(to freqRange: ClosedRange<Float>) {
        TranscriberAudioEngine.shared.setFilterFreqRange(freqRange)
    }
}

extension TranscribeViewController: VerticalPickerDelegate {
    func verticalPicker(_ picker: VerticalPicker, didSelect value: Float) {
        if picker === centsPicker || picker === semitonesPicker {
            let semitones = Float(semitonesPicker.value)
            let cents = Float(centsPicker.value)
            TranscriberAudioEngine.shared.setPitchShift(semitones, cents: cents)
        } else if picker === speedPicker {
            TranscriberAudioEngine.shared.setSpeed(Double(value))
        }
    }
}

extension TranscribeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)

        if let url = info[.mediaURL] as? URL {
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let documentDirectoryUrl = URL(fileURLWithPath: documentDirectory)
            let destinationUrl = documentDirectoryUrl.appendingPathComponent(url.lastPathComponent)
            try? FileManager.default.copyItem(at: url, to: destinationUrl)

            let asset = AVAsset(url: destinationUrl)
            let audioTrackName = (url.lastPathComponent.components(separatedBy: ".").first ?? "audio") + ".m4a"
            let audioTrackUrl = documentDirectoryUrl.appendingPathComponent(audioTrackName)
            asset.writeAudioTrack(to: audioTrackUrl) {
                DispatchQueue.main.async {
                    self.loadAudio(atUrl: audioTrackUrl)
                    self.loadVideo(atUrl: destinationUrl)
                }
            } failure: { error in
                print(error.localizedDescription)
            }
        }

        if let url = info[.imageURL] as? URL {
            try? FileManager.default.removeItem(at: url)
        } else if let url = info[.mediaURL] as? URL {
            try? FileManager.default.removeItem(at: url)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
