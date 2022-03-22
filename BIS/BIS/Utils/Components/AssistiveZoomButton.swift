//
//  AssistiveZoomButton.swift
//  BIS
//
//  Created by TSSIOS on 23/07/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

class AssistiveZoomButton: UIButton {

    var panner: UIPanGestureRecognizer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializeButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initializeButton()
        fatalError("init(coder:) has not been implemented")
    }

    func assistiveZoomButtonAction(action: @escaping ActionHandler) {
        self.zoomButton(action: action)
    }

    func initializeButton() {
        self.setImage(#imageLiteral(resourceName: "fullScreenEnter"), for: .normal)
        self.setImage(#imageLiteral(resourceName: "fullScreenExit "), for: .selected)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.alpha = 0.2
        }

        panner = UIPanGestureRecognizer(target: self, action: #selector(self.panDidFire(panner:)))
        panner?.delegate = self as? UIGestureRecognizerDelegate

        self.addGestureRecognizer(panner!)
    }

    //back action
    private func zoomButton(action: @escaping  ActionHandler) {

        self.ngl_addAction(forControlEvents: .touchUpInside, withCallback: {
            self.jumpButtonEffect()
            self.isSelected = !self.isSelected
            self.alpha = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                self.alpha = 0.2
            }
            action(self)
        })

        panner = UIPanGestureRecognizer(target: self, action: #selector(self.panDidFire(panner:)))
        panner?.delegate = self as? UIGestureRecognizerDelegate

        self.addGestureRecognizer(panner!)
    }

    @objc func panDidFire(panner: UIPanGestureRecognizer) {
        let offset = panner.translation(in: self.superview)
        panner.setTranslation(CGPoint.zero, in: self.superview)
        var center = self.center
        center.x += offset.x
        center.y += offset.y
        self.center = center
        self.alpha = 1.0
        var btnFrame = self.frame

        if panner.state == .ended || panner.state == .cancelled {
            if self.frame.origin.x < 0 {
                btnFrame.origin.x = -5
            }
            if self.frame.origin.x+50 > UIScreen.main.bounds.width {
                btnFrame.origin.x = UIScreen.main.bounds.width - 50

            }
            if self.frame.origin.y < (UIApplication.shared.windows.first {$0.isKeyWindow }?.safeAreaInsets.top ?? 0) + 100 {
                btnFrame.origin.y = (UIApplication.shared.windows.first {$0.isKeyWindow }?.safeAreaInsets.top ?? 0) + 100

            }
            if self.frame.origin.y+70 > UIScreen.main.bounds.height {
                btnFrame.origin.y = UIScreen.main.bounds.height - 180
            }

            if self.frame.origin.x + self.frame.size.width-30 > UIScreen.main.bounds.width/2 {
                btnFrame.origin.x = UIScreen.main.bounds.width-55
            } else {
                btnFrame.origin.x = UIScreen.main.bounds.origin.x - 5
            }
            UIView.animate(withDuration: 0.3) {
                self.frame = btnFrame
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.alpha = 0.2
            }
        }
    }
}
