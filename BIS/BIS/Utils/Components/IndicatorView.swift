//
//  IndicatorView.swift
//  BIS
//
//  Created by TSSIOS on 29/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Activity Indicator Type
public enum ActivityIndicatorStyle {
    case defaultSpinner
    case spinningFadeCircle
}

public class IndicatorView {
    // MARK: - Custom Properties

    var window: UIWindow?
    var backgroundView: UIView?
    var activityIndicatorView: UIToolbar?
    var spinnerContainerView: UIView?
    var statusLabel: UILabel?

    /// ActivityIndicator Customization
    fileprivate var statusLabelFont: UIFont = BISFont.h16.regular
    fileprivate var statusTextColor: UIColor = UIColor.darkGray1
    fileprivate var spinnerColor: UIColor = UIColor.darkGray1
    fileprivate var backgroundViewColor: UIColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
    fileprivate var spinnerContainerViewColor: UIColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
    fileprivate var activityIndicatorStyle: ActivityIndicatorStyle = .defaultSpinner
    fileprivate var activityIndicatorTranslucency: UIBlurEffect.Style = .dark

    // MARK: - Singleton Accessors

    fileprivate static let shared: IndicatorView = {
        let instance = IndicatorView()
        // Do any additional Configuration
        return instance
    }()

    // MARK: - Initialization

    private init() {
        statusLabel = nil
        backgroundView = nil
        spinnerContainerView = nil
        activityIndicatorView = nil
    }

    // MARK: - Display Methods

    /**
     Display Activity-Indicator without status message

     */
    public static func show() {
        DispatchQueue.main.async {
            self.shared.configureActivityIndicator(withStatusMessage: "", isUserInteractionEnabled: true)
        }
    }

    /**
     Display Activity-Indicator with status message

     - parameter message : Status message display with activity indicator
     */
    public static func show(_ message: String) {
        DispatchQueue.main.async {
            self.shared.configureActivityIndicator(withStatusMessage: message, isUserInteractionEnabled: true)
        }
    }

    /**
     Display Activity-Indicator with status message and user interaction enabled or disabled.
     The "userInteractionStatus" allows to enable or disable user interaction with other UI elements while Activity-Indicator being displayed.

     - parameter message : Status message display with activity indicator
     - parameter userInteractionStatus : Set true to enble user interaction and false to disable
     */
    public static func show(_ message: String, userInteractionStatus: Bool) {
        DispatchQueue.main.async {
            self.shared.configureActivityIndicator(withStatusMessage: message, isUserInteractionEnabled: userInteractionStatus)
        }
    }

    // MARK: - Hide Methods

    /**
     Hide Activity-Indicator

     */
    public static func dismiss() {
        DispatchQueue.main.async {
            self.shared.hideActivityIndicator()
        }
    }

    // MARK: - Configure Activity Indicator

    fileprivate func configureActivityIndicator(withStatusMessage message: String, isUserInteractionEnabled userInteractionStatus: Bool) {

        if #available(iOS 13.0, *) {
            if let windowObj = getKeyWindow() {
                window = windowObj
            }
        } else {
            // Fallback on earlier versions
            if let delegate: UIApplicationDelegate = UIApplication.shared.delegate {
                if let windowObj = delegate.window {
                    window = windowObj
                }
            }
        }

        /// Setup Activity Indicator View
        if activityIndicatorView == nil {
            activityIndicatorView = UIToolbar(frame: CGRect.zero)
            activityIndicatorView!.layer.cornerRadius = 8
            activityIndicatorView!.layer.masksToBounds = true
            activityIndicatorView!.isTranslucent = true
        }

        /// Setup Spinner Container View
        if spinnerContainerView == nil {
            let spinnerViewFrame = CGRect(x: 0, y: 0, width: 37, height: 37)
            spinnerContainerView = UIView(frame: spinnerViewFrame)
            spinnerContainerView!.backgroundColor = self.spinnerContainerViewColor
        }

        /// Setup Spinner
        if spinnerContainerView != nil {
            spinnerContainerView?.removeFromSuperview()
            spinnerContainerView = nil

            let spinnerViewFrame = CGRect(x: 0, y: 0, width: 37, height: 37)
            spinnerContainerView = UIView(frame: spinnerViewFrame)
            spinnerContainerView!.backgroundColor = UIColor.clear

            let viewLayer = spinnerContainerView!.layer
            let animationRectsize = CGSize(width: 37, height: 37)
            IndicatorViewStyle.createSpinner(in: viewLayer, size: animationRectsize, color: spinnerColor, style: activityIndicatorStyle)
        }

        if spinnerContainerView?.superview == nil {
            activityIndicatorView!.addSubview(spinnerContainerView!)
        }

        if activityIndicatorView?.superview == nil && userInteractionStatus == false {
            backgroundView = UIView(frame: window!.frame)
            backgroundView!.backgroundColor = backgroundViewColor
            window!.addSubview(backgroundView!)
            backgroundView!.addSubview(activityIndicatorView!)
        } else {
            window!.addSubview(activityIndicatorView!)
        }

        /// Setup Status Message Label
        if statusLabel == nil {
            statusLabel = UILabel(frame: CGRect.zero)
            statusLabel!.font = statusLabelFont
            statusLabel!.textColor = statusTextColor
            statusLabel!.backgroundColor = UIColor.clear
            statusLabel!.textAlignment = .center
            statusLabel!.baselineAdjustment = .alignCenters
            statusLabel!.numberOfLines = 0
        }
        if statusLabel?.superview == nil {
            activityIndicatorView!.addSubview(statusLabel!)
        }
        statusLabel?.text = message
        statusLabel?.isHidden = (message.count == 0) ? true : false

        /// Setup Activity IndicatorView Size & Position
        configureActivityIndicatorSize()
        configureActivityIndicatorPosition(notification: nil)
        showActivityIndicator()
    }

    // MARK: - Configure ActivityIndicator

    fileprivate func configureActivityIndicatorSize() {
        var rectLabel: CGRect = CGRect.zero
        var widthHUD: CGFloat = 100
        var heightHUD: CGFloat = 100

        if let statusMessage = statusLabel?.text, statusMessage.count != 0 {
            let attributes = [NSAttributedString.Key.font: statusLabel?.font]
            let options: NSStringDrawingOptions = [.usesFontLeading, .truncatesLastVisibleLine, .usesLineFragmentOrigin]
            rectLabel = (statusLabel?.text?.boundingRect(with: CGSize(width: 200, height: 300), options: options, attributes: attributes as [NSAttributedString.Key: AnyObject], context: nil))!
            widthHUD = rectLabel.size.width + 40
            heightHUD = rectLabel.size.height + 75
            if widthHUD < 100 {
                widthHUD = 100
            }
            if heightHUD < 100 {
                heightHUD = 100
            }
            rectLabel.origin.x = (widthHUD - rectLabel.size.width) / 2
            rectLabel.origin.y = (heightHUD - rectLabel.size.height) / 2 + 25
        }

        activityIndicatorView?.bounds = CGRect(x: 0, y: 0, width: widthHUD, height: heightHUD)

        let imageX: CGFloat = widthHUD / 2
        let imageY: CGFloat = (statusLabel!.text?.count == 0) ? heightHUD / 2 : 36
        spinnerContainerView!.center = CGPoint(x: imageX, y: imageY)
        statusLabel?.frame = rectLabel
    }

    // MARK: - ActivityIndicator Position

    @objc fileprivate func configureActivityIndicatorPosition(notification: NSNotification?) {

        let screen: CGRect = UIScreen.main.bounds
        let center: CGPoint = CGPoint(x: screen.size.width / 2, y: screen.size.height / 2)

        UIView.animate(withDuration: 0, delay: 0, options: [.allowUserInteraction], animations: {
            self.activityIndicatorView?.center = CGPoint(x: center.x, y: center.y)
        }, completion: nil)

        if backgroundView != nil {
            backgroundView!.frame = window!.frame
        }
    }

    // MARK: - Show

    fileprivate func showActivityIndicator() {
        if activityIndicatorView != nil {
            activityIndicatorView!.alpha = 0
            UIView.animate(withDuration: 0.1, animations: {
                self.activityIndicatorView?.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
                self.activityIndicatorView?.alpha = 1
            }, completion: { _ in
                UIView.animate(withDuration: 0.2, animations: { () -> Void in
                    self.activityIndicatorView?.transform = CGAffineTransform.identity
                }, completion: nil)
            })
        }
    }

    // MARK: - Hide

    fileprivate func hideActivityIndicator() {
        if activityIndicatorView != nil && activityIndicatorView?.alpha == 1 {
            UIView.animate(withDuration: 0.15, delay: 0, options: [.allowUserInteraction, .curveEaseIn], animations: {
                self.activityIndicatorView?.transform = CGAffineTransform.identity.scaledBy(x: 0.7, y: 0.7)
                self.activityIndicatorView?.alpha = 0
            }, completion: { _ in
                self.activityIndicatorView?.alpha = 0
                self.deallocateActivityIndicator()
            })
        }
    }

    // MARK: - Deallocate ActivityIndicator

    fileprivate func deallocateActivityIndicator() {
        statusLabel?.removeFromSuperview()
        statusLabel = nil
        spinnerContainerView?.removeFromSuperview()
        spinnerContainerView = nil
        activityIndicatorView?.removeFromSuperview()
        activityIndicatorView = nil
        backgroundView?.removeFromSuperview()
        backgroundView = nil
    }

    // MARK: - Customization Methods

    public static func statusLabelFont(_ font: UIFont) {
        shared.statusLabelFont = font
    }

    public static func statusTextColor(_ color: UIColor) {
        shared.statusTextColor = color
    }

    public static func spinnerColor(_ color: UIColor) {
        shared.spinnerColor = color
    }

    public static func backGroundColor(_ color: UIColor) {
        shared.backgroundViewColor = color
    }

    public static func spinnerContainerViewColor(_ color: UIColor) {
        shared.spinnerContainerViewColor = color
    }

    public static func spinnerStyle(_ spinnerStyle: ActivityIndicatorStyle) {
        shared.activityIndicatorStyle = spinnerStyle
    }

    // MARK: - Helper Methods
    @available(iOS 13.0, *)
    fileprivate func getKeyWindow() -> UIWindow? {
        let window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first

        return window
    }
}

class IndicatorViewStyle: NSObject {
    static let shared = IndicatorViewStyle()
    private override init() {}

    /**
     Create Activity-Indicator based on provided style

     - parameter layer : Spinner containerview layer
     - parameter size  : Size of spinner
     - parameter color : Color of spinner, default is "lightGray"
     - parameter style : Spinner style specified by user, default style is "defaultSpinner"
     */
    class func createSpinner(in layer: CALayer, size: CGSize, color: UIColor, style: ActivityIndicatorStyle) {
        switch style {
        case .defaultSpinner:
            shared.createCircularLineFadingActivityIndicator(in: layer, size: size, color: color)

        case .spinningFadeCircle:
            shared.createCircularSpinningBallWithFadingActivityIndicator(in: layer, size: size, color: color)
        }
    }

    // MARK: - Create Spinner

    // ---------------------------------------------------Line Fade Spinner ---------------------------------------------- //
    // ------------------------------------------------------------------------------------------------------------------- //
    func createCircularLineFadingActivityIndicator(in layer: CALayer, size: CGSize, color: UIColor) {
        let lineSpacing: CGFloat = 1
        let lineSize = CGSize(width: (size.width - 20 * lineSpacing) / 5, height: (size.height - 6 * lineSpacing) / 3)
        let x = (layer.bounds.size.width - size.width) / 2
        let y = (layer.bounds.size.height - size.height) / 2
        let duration: CFTimeInterval = 0.5
        let beginTime = CACurrentMediaTime()
        let beginTimes: [CFTimeInterval] = [0.12, 0.24, 0.36, 0.48, 0.6, 0.72, 0.84, 0.96, 0.108, 0.120]
        let timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)

        // Animation
        let animation = CAKeyframeAnimation(keyPath: "opacity")
        animation.keyTimes = [0, 0.5, 1]
        animation.timingFunctions = [timingFunction, timingFunction]
        animation.values = [1, 0.3, 1]
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false

        // Draw lines
        for i in 0 ..< 10 {
            let line = lineAt(angle: CGFloat(Double.pi / 5 * Double(i)),
                              size: lineSize,
                              origin: CGPoint(x: x, y: y),
                              containerSize: size,
                              color: color)

            animation.beginTime = beginTime + beginTimes[i]
            line.add(animation, forKey: "animation")
            layer.addSublayer(line)
        }
    }

    func lineAt(angle: CGFloat, size: CGSize, origin: CGPoint, containerSize: CGSize, color: UIColor) -> CALayer {
        let radius = containerSize.width / 2 - max(size.width, size.height) / 2
        let lineContainerSize = CGSize(width: max(size.width, size.height), height: max(size.width, size.height))
        let lineContainer = CALayer()
        let lineContainerFrame = CGRect(
            x: origin.x + radius * (cos(angle) + 1),
            y: origin.y + radius * (sin(angle) + 1),
            width: lineContainerSize.width,
            height: lineContainerSize.height
        )
        let line = circularLineFadingActivityIndicatorlayerWith(size: size, color: color)
        let lineFrame = CGRect(
            x: (lineContainerSize.width - size.width) / 2,
            y: (lineContainerSize.height - size.height) / 2,
            width: size.width,
            height: size.height
        )

        lineContainer.frame = lineContainerFrame
        line.frame = lineFrame
        lineContainer.addSublayer(line)
        lineContainer.sublayerTransform = CATransform3DMakeRotation(CGFloat(Double.pi / 2) + angle, 0, 0, 1)

        return lineContainer
    }

    func circularLineFadingActivityIndicatorlayerWith(size: CGSize, color: UIColor) -> CALayer {
        let layer: CAShapeLayer = CAShapeLayer()
        var path: UIBezierPath = UIBezierPath()

        path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height), cornerRadius: size.width / 2)
        layer.fillColor = color.cgColor

        layer.backgroundColor = nil
        layer.path = path.cgPath
        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        return layer
    }

    // ------------------------------------------------------------------------------------------------------------------- //

    // ---------------------------------------------------Ball Spin Fade Spinner ----------------------------------------- //
    // ------------------------------------------------------------------------------------------------------------------- //

    func createCircularSpinningBallWithFadingActivityIndicator(in layer: CALayer, size: CGSize, color: UIColor) {
        let circleSpacing: CGFloat = -2
        let circleSize = (size.width - 4 * circleSpacing) / 5
        let x = (layer.bounds.size.width - size.width) / 2
        let y = (layer.bounds.size.height - size.height) / 2
        let duration: CFTimeInterval = 1
        let beginTime = CACurrentMediaTime()
        let beginTimes: [CFTimeInterval] = [0, 0.12, 0.24, 0.36, 0.48, 0.6, 0.72, 0.84]

        // Scale animation
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")

        scaleAnimation.keyTimes = [0, 0.5, 1]
        scaleAnimation.values = [1, 0.4, 1]
        scaleAnimation.duration = duration

        // Opacity animation
        let opacityAnimaton = CAKeyframeAnimation(keyPath: "opacity")

        opacityAnimaton.keyTimes = [0, 0.5, 1]
        opacityAnimaton.values = [1, 0.3, 1]
        opacityAnimaton.duration = duration

        // Animation
        let animation = CAAnimationGroup()

        animation.animations = [scaleAnimation, opacityAnimaton]
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false

        // Draw circles
        for i in 0 ..< 8 {
            let circle = circleAt(angle: CGFloat(Double.pi / 4) * CGFloat(i),
                                  size: circleSize,
                                  origin: CGPoint(x: x, y: y),
                                  containerSize: size,
                                  color: color)

            animation.beginTime = beginTime + beginTimes[i]
            circle.add(animation, forKey: "animation")
            layer.addSublayer(circle)
        }
    }

    func circleAt(angle: CGFloat, size: CGFloat, origin: CGPoint, containerSize: CGSize, color: UIColor) -> CALayer {
        let radius = containerSize.width / 2 - size / 2
        let circle = spinningBallWithFadingActivityIndicatorlayerWith(size: CGSize(width: size, height: size), color: color)
        let frame = CGRect(
            x: origin.x + radius * (cos(angle) + 1),
            y: origin.y + radius * (sin(angle) + 1),
            width: size,
            height: size
        )

        circle.frame = frame
        return circle
    }

    func spinningBallWithFadingActivityIndicatorlayerWith(size: CGSize, color: UIColor) -> CALayer {
        let layer: CAShapeLayer = CAShapeLayer()
        let path: UIBezierPath = UIBezierPath()

        path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                    radius: size.width / 2,
                    startAngle: 0,
                    endAngle: CGFloat(2 * Double.pi),
                    clockwise: false)
        layer.fillColor = color.cgColor

        layer.backgroundColor = nil
        layer.path = path.cgPath
        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        return layer
    }

}
