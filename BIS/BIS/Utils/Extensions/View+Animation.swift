//
//  View+Animation.swift
//  BIS
//
//  Created by TSSIOS on 21/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

private enum Axis: StringLiteralType {
    case xAxis = "x"
    case yAxis = "y"
}

extension UIView {

    //Shake Animation
    func shake(duration: CFTimeInterval) {
        let translation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        translation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        translation.values = [-5, 5, -5, 5, -3, 3, -2, 2, 0]

        let rotation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotation.values = [-5, 5, -5, 5, -3, 3, -2, 2, 0].map {( degrees: Double) -> Double in
            let radians: Double = (.pi * degrees) / 180.0
            return radians
        }

        let shakeGroup: CAAnimationGroup = CAAnimationGroup()
        shakeGroup.animations = [translation, rotation]
        shakeGroup.duration = duration
        self.layer.add(shakeGroup, forKey: "shakeIt")
    }

    private func shake(on axis: Axis) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.\(axis.rawValue)")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20, 20, -20, 20, -10, 10, -5, 5, 0]
        layer.add(animation, forKey: "shake")
    }

    func shakeOnXAxis() {
        self.shake(on: .xAxis)
    }

    func shakeOnYAxis() {
        self.shake(on: .yAxis)
    }

    //Fade Animation
    func fadeTo(_ alpha: CGFloat, duration: TimeInterval = 0.3) {
      DispatchQueue.main.async {
        UIView.animate(withDuration: duration) {
          self.alpha = alpha
        }
      }
    }

    func fadeIn(_ duration: TimeInterval = 0.3) {
      fadeTo(1.0, duration: duration)
    }

    func fadeOut(_ duration: TimeInterval = 0.3) {
      fadeTo(0.0, duration: duration)
    }

    func addSubviewWithZoomInAnimation(_ view: UIView, startingFrame: CGRect, duration: TimeInterval, options: UIView.AnimationOptions, isViewAdded: Bool = false) {
        let widthScale = startingFrame.width/view.bounds.width
        let heightScale = startingFrame.height/view.bounds.height
        
        let c1 = startingFrame.minY + startingFrame.height/2
        let yNew = c1 - (view.frame.minY + view.bounds.height/2)
        
        let c2 = startingFrame.minX + startingFrame.width/2
        let xNew = c2 - (view.frame.minX + view.bounds.width/2)

        let scaleTransform = CGAffineTransform(scaleX: widthScale, y: heightScale)
        let translateTransform = CGAffineTransform(translationX: xNew, y: yNew)
        
        view.transform = scaleTransform.concatenating(translateTransform)
        if !isViewAdded {
            addSubview(view)
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            view.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    func removeWithZoomOutAnimation(duration: TimeInterval, endingFrame: CGRect, options: UIView.AnimationOptions, isViewAdded: Bool = false, completionHandler: (() -> Void)? = nil) {
        
        let widthScale = endingFrame.width/bounds.width
        let heightScale = endingFrame.height/bounds.height
        
        let c1 = endingFrame.minY + endingFrame.height/2
        let yNew = c1 - (frame.minY + bounds.height/2)
        
        let c2 = endingFrame.minX + endingFrame.width/2
        let xNew = c2 - (frame.minX + bounds.width/2)

        let scaleTransform = CGAffineTransform(scaleX: widthScale, y: heightScale)
        let translateTransform = CGAffineTransform(translationX: xNew, y: yNew)
        
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            self.transform = scaleTransform.concatenating(translateTransform)
        }, completion: { _ in
            
            if !isViewAdded {
                self.removeFromSuperview()
            }
            completionHandler?()
        })
    }
}
