//
//  Button+Animation.swift
//  BIS
//
//  Created by TSSIOS on 21/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

extension UIButton {

    func bounceButtonEffect() {
        UIView.animate(withDuration: 0.10,
        animations: {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        },
        completion: { _ in
            UIView.animate(withDuration: 0.05) {
                self.transform = CGAffineTransform.identity
            }
        })
    }

    func jumpButtonEffect() {
        UIView.animate(withDuration: 0.425,
        animations: {
            self.transform = CGAffineTransform(scaleX: 1.07, y: 1.07)
        },
        completion: { _ in
            UIView.animate(withDuration: 0.4) {
                self.transform = CGAffineTransform.identity
            }
        })
    }
}
