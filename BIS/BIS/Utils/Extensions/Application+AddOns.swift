//
//  Application+AddOns.swift
//  BIS
//
//  Created by TSSIOS on 17/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        return keyWindow?.rootViewController?.topMostViewController()
    }
}

extension UIDevice {

    /// Returns 'true' if the device has a notch
    var hasNotch: Bool {
        if let interfaceOrientation = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.windowScene?.interfaceOrientation {
            let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
            if interfaceOrientation.isPortrait {
                return keyWindow?.safeAreaInsets.top ?? 0.0 >= 44.0
            } else {
                return keyWindow?.safeAreaInsets.left ?? 0.0 > 0.0 || keyWindow?.safeAreaInsets.right ?? 0.0 > 0.0
            }
        } else {
            return false
        }
    }

}
