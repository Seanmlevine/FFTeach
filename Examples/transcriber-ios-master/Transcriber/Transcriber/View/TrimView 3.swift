//
//  TrimView.swift
//  TrimView
//
//  Created by Daniel Kuntz on 8/15/21.
//

import UIKit

protocol TrimViewDelegate: AnyObject {
    func trimmed(to progressRange: ClosedRange<Float>)
}

protocol TrimViewTouchHandler: AnyObject {
    func handleTouchDown()
    func handleTouchUp()
}

class TrimView: UIView {

    var color: UIColor = UIColor(hex: "727275")
    var trimViewBgColor: UIColor = .clear
    var handleColor: UIColor = .white
    private let bgColor: UIColor = UIColor(hex: "2B2B2E")

    private let handleWidth: CGFloat = 3
    private let topBottomBorderWidth: CGFloat = 2
    let leftRightBorderWidth: CGFloat = 18
    private let minBorderDistance: CGFloat = 20

    private var leftBorder: UIView!
    private var leftHandle: UIView!
    private var rightBorder: UIView!
    private var rightHandle: UIView!

    private var leftConstraint: NSLayoutConstraint!
    private var rightConstraint: NSLayoutConstraint!

    private var panGR: UIPanGestureRecognizer!
    private var panning: Bool = false
    private var panStartX: CGFloat = 0
    private var constraintStartValue: CGFloat = 0
    private var panningConstraint: NSLayoutConstraint?

    private var touchDownGR: UILongPressGestureRecognizer!
    private var touchedHandle: Bool = false

    private var feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)

    weak var delegate: TrimViewDelegate?
    weak var touchHandler: TrimViewTouchHandler?
    var extendsProgressRange: Bool = true
    private(set) var progressRange: ClosedRange<Float> = 0...1

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)

        backgroundColor = .clear

        let leftDimmingView = UIView()
        leftDimmingView.backgroundColor = bgColor.withAlphaComponent(0.85)
        leftDimmingView.layer.cornerRadius = 8
        leftDimmingView.layer.cornerCurve = .continuous
        addSubview(leftDimmingView)

        let rightDimmingView = UIView()
        rightDimmingView.backgroundColor = bgColor.withAlphaComponent(0.85)
        rightDimmingView.layer.cornerRadius = 8
        rightDimmingView.layer.cornerCurve = .continuous
        addSubview(rightDimmingView)

        let centerDimmingView = UIView()
        centerDimmingView.backgroundColor = trimViewBgColor
        addSubview(centerDimmingView)

        leftBorder = UIView()
        leftBorder.backgroundColor = color
        leftBorder.layer.cornerRadius = 8
        leftBorder.layer.cornerCurve = .continuous
        leftBorder.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        addSubview(leftBorder)

        leftHandle = UIView()
        leftHandle.backgroundColor = handleColor
        leftHandle.layer.cornerRadius = handleWidth / 2
        leftBorder.addSubview(leftHandle)

        rightBorder = UIView()
        rightBorder.backgroundColor = color
        rightBorder.layer.cornerRadius = 8
        rightBorder.layer.cornerCurve = .continuous
        rightBorder.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        addSubview(rightBorder)

        rightHandle = UIView()
        rightHandle.backgroundColor = handleColor
        rightHandle.layer.cornerRadius = handleWidth / 2
        rightBorder.addSubview(rightHandle)

        let topBorder = UIView()
        topBorder.backgroundColor = color
        addSubview(topBorder)

        let bottomBorder = UIView()
        bottomBorder.backgroundColor = color
        addSubview(bottomBorder)

        leftBorder.autoSetDimension(.width, toSize: leftRightBorderWidth)
        leftBorder.autoPinEdge(toSuperviewEdge: .top)
        leftBorder.autoPinEdge(toSuperviewEdge: .bottom)
        leftBorder.autoPinEdge(toSuperviewEdge: .leading, withInset: 0, relation: .greaterThanOrEqual)
        leftConstraint = leftBorder.autoPinEdge(toSuperviewEdge: .leading)
        leftConstraint.priority = .defaultHigh
        leftHandle.autoMatch(.height, to: .height, of: leftBorder, withMultiplier: 0.77)
        leftHandle.autoSetDimension(.width, toSize: handleWidth)
        leftHandle.autoCenterInSuperview()

        rightBorder.autoSetDimension(.width, toSize: leftRightBorderWidth)
        rightBorder.autoPinEdge(toSuperviewEdge: .top)
        rightBorder.autoPinEdge(toSuperviewEdge: .bottom)
        rightBorder.autoPinEdge(toSuperviewEdge: .trailing, withInset: 0, relation: .greaterThanOrEqual)
        rightConstraint = rightBorder.autoPinEdge(toSuperviewEdge: .trailing)
        rightConstraint.priority = .defaultHigh
        rightHandle.autoMatch(.height, to: .height, of: rightBorder, withMultiplier: 0.77)
        rightHandle.autoSetDimension(.width, toSize: handleWidth)
        rightHandle.autoCenterInSuperview()

        topBorder.autoPinEdge(toSuperviewEdge: .top)
        topBorder.autoPinEdge(.leading, to: .trailing, of: leftBorder)
        topBorder.autoPinEdge(.trailing, to: .leading, of: rightBorder)
        topBorder.autoSetDimension(.height, toSize: topBottomBorderWidth)

        bottomBorder.autoPinEdge(toSuperviewEdge: .bottom)
        bottomBorder.autoPinEdge(.leading, to: .trailing, of: leftBorder)
        bottomBorder.autoPinEdge(.trailing, to: .leading, of: rightBorder)
        bottomBorder.autoSetDimension(.height, toSize: topBottomBorderWidth)

        leftDimmingView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .trailing)
        leftDimmingView.autoPinEdge(.trailing, to: .trailing, of: leftBorder)

        rightDimmingView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .leading)
        rightDimmingView.autoPinEdge(.leading, to: .leading, of: rightBorder)

        centerDimmingView.autoPinEdge(.leading, to: .trailing, of: leftBorder)
        centerDimmingView.autoPinEdge(.top, to: .bottom, of: topBorder)
        centerDimmingView.autoPinEdge(.trailing, to: .leading, of: rightBorder)
        centerDimmingView.autoPinEdge(.bottom, to: .top, of: bottomBorder)

        panGR = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(_:)))
        panGR.delegate = self
        panGR.cancelsTouchesInView = false
        addGestureRecognizer(panGR)

        touchDownGR = UILongPressGestureRecognizer(target: self, action: #selector(touchDownHandler(_:)))
        touchDownGR.minimumPressDuration = 0
        touchDownGR.delegate = self
        touchDownGR.cancelsTouchesInView = false
        addGestureRecognizer(touchDownGR)
    }

    func setProgressRange(_ range: ClosedRange<Float>) {
        let lowerConstraint = bounds.width * CGFloat(range.lowerBound) - (extendsProgressRange ? 0 : leftRightBorderWidth)
        let upperConstraint = -1 * (bounds.width * CGFloat(1 - range.upperBound) - (extendsProgressRange ? 0 : leftRightBorderWidth))
        leftConstraint.constant = lowerConstraint
        rightConstraint.constant = upperConstraint
        layoutIfNeeded()
        sendProgressToDelegate()
    }

    func sendProgressToDelegate() {
        let lowerX = Float(leftBorder.frame.origin.x) + Float(extendsProgressRange ? 0 : leftRightBorderWidth)
        let upperX = Float(rightBorder.frame.origin.x) + Float(extendsProgressRange ? leftRightBorderWidth : 0)
        let lowerProgress = lowerX / Float(bounds.width)
        let upperProgress = upperX / Float(bounds.width)
        progressRange = lowerProgress...upperProgress
        delegate?.trimmed(to: lowerProgress...upperProgress)
    }

    @objc private func touchDownHandler(_ recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            let location = recognizer.location(in: self)
            let distances: [CGFloat] = [leftBorder, rightBorder].map { border in
                let centerX = border!.frame.origin.x + border!.frame.width / 2
                return abs(location.x - centerX)
            }
            let minDistance = distances.min()!
            guard minDistance < 50 else {
                return
            }

            touchHandler?.handleTouchDown()
            touchedHandle = true
            panning = true
            panStartX = location.x
            feedbackGenerator.impactOccurred(intensity: 1)

            if minDistance == distances[0] {
                constraintStartValue = leftConstraint.constant
                panningConstraint = leftConstraint
                rightConstraint.priority = .required
                grabLeftHandleAnimation()
            } else {
                constraintStartValue = rightConstraint.constant
                panningConstraint = rightConstraint
                leftConstraint.priority = .required
                grabRightHandleAnimation()
            }
        }
    }

    @objc private func panGestureHandler(_ recognizer: UIGestureRecognizer) {
        switch recognizer.state {
        case .began:
            if panning {
                panStartX = recognizer.location(in: self).x
            }
        case .changed:
            if panning {
                let curX = recognizer.location(in: self).x
                let newConstant = constraintStartValue + (curX - panStartX)
                if panningConstraint === leftConstraint {
                    let lowerBounds: CGFloat = 0
                    let upperBounds = rightBorder.frame.origin.x - minBorderDistance - leftRightBorderWidth
                    panningConstraint?.constant = newConstant.clamped(to: lowerBounds...upperBounds)
                } else {
                    let lowerBounds = -1 * ((bounds.width - leftBorder.frame.origin.x) - (leftRightBorderWidth * 2) - minBorderDistance)
                    let upperBounds: CGFloat = 0
                    panningConstraint?.constant = newConstant.clamped(to: lowerBounds...upperBounds)
                }
                layoutIfNeeded()
                sendProgressToDelegate()
            }
        case .ended, .cancelled, .failed:
            panning = false
            leftConstraint.priority = .defaultHigh
            rightConstraint.priority = .defaultHigh
        default: break
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        touchHandler?.handleTouchUp()
        if touchedHandle {
            resetHandlesAnimation()
            touchedHandle = false
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        if touchedHandle {
            resetHandlesAnimation()
            touchedHandle = false
        }
    }

    private func grabLeftHandleAnimation() {
        UIView.animate(withDuration: 0.1) {
            self.leftHandle.alpha = 0.6
        }
    }

    private func grabRightHandleAnimation() {
        UIView.animate(withDuration: 0.1) {
            self.rightHandle.alpha = 0.6
        }
    }

    private func resetHandlesAnimation() {
        feedbackGenerator.impactOccurred(intensity: 0.5)
        UIView.animate(withDuration: 0.1) {
            self.leftHandle.transform = .identity
            self.leftHandle.alpha = 1
            self.rightHandle.transform = .identity
            self.rightHandle.alpha = 1
        }
    }
}

extension TrimView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
