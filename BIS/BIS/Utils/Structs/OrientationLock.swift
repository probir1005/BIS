//
//  OrientationLock.swift
//  BIS
//
//  Created by TSSIOS on 10/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

struct OrientationLock {
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }

    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation: UIInterfaceOrientation) {
        self.lockOrientation(orientation)
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
}
