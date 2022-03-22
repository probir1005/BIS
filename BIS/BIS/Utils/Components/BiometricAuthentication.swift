//
//  BiometricAuthentication.swift
//  BIS
//
//  Created by TSSIOS on 12/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation
import LocalAuthentication

class BiometricAuthentication {

    enum Kind {
        case none
        case touchID
        case faceID
    }

    let context = LAContext()

    func canEvaluatePolicy() -> Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }

    var biometricType: BiometricAuthentication.Kind {
        let evaluate = self.canEvaluatePolicy()
        if #available(iOS 11.0, *) {
            switch context.biometryType {
            case .none:
                return .none
            case .touchID:
                return .touchID
            case .faceID:
                return .faceID
            @unknown default:
                return .none
            }
        } else {
            return evaluate ? .touchID : .none
        }
    }

    func authenticateUser(completion: @escaping (Bool, Error?) -> Void) {
        guard self.canEvaluatePolicy() else {
            return
        }

        self.context.localizedFallbackTitle = ""

        self.context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Logging in with \(biometricType)") { (success, error) in
            DispatchQueue.main.async { completion(success, error) }
        }
    }

}
