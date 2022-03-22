//
//  BISBiometricsVC.swift
//  BIS
//
//  Created by TSSIOS on 15/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit
import KeychainSwift
import LocalAuthentication

protocol BiometricsRouter: class {
    var onSkip: (() -> Void)? { get set }
    var onFinish: (() -> Void)? { get set }
}

class BISBiometricsVC: BaseViewController, BiometricsRouter {

    var onSkip: (() -> Void)?
    var onFinish: (() -> Void)?
    
    @IBOutlet weak var enableButton: UIButton!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var biometricsImageView: UIImageView!
    let bioAuth = BiometricAuthentication()
    var biometricsType = ""
    var appPINCode = ""

    private var appKeyChain = KeyChainService()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let appPIN = self.appKeyChain.get(.appLockPIN) {
            self.appPINCode = appPIN
            self.appKeyChain.clear()
        }
        checkBiometricType()
        // Do any additional setup after loading the view.
    }

    @IBAction func enableBiometricsButtonTapped(_ sender: Any) {
        self.authenticate()
    }
    
    @IBAction func skipButtonTapped(_ sender: Any) {
        UserDefaults.setVal(value: false, forKey: UserDefaultsKey.enableBio)
        self.appKeyChain.set(.appLockPIN, value: self.appPINCode)
        onSkip?()
    }

    func authenticate() {
        self.bioAuth.authenticateUser(completion: { success, error in
            var biometricCode: Int?
                biometricCode = LAError.Code.biometryLockout.rawValue
            if error != nil {
                if error?.codeFromError == biometricCode {
                    UIAlertController.alert("", message: error?.localizedDescription).show()
                } else {
//                    UIAlertController.alert("", message: "Something went wrong. Please try again later.").show()
                }
            } else if success {
                UserDefaults.setVal(value: true, forKey: UserDefaultsKey.enableBio)
                self.appKeyChain.set(.appLockPIN, value: self.appPINCode)
                self.onFinish?()
            }
        })
    }

    func checkBiometricType() {
        switch bioAuth.biometricType {
        case .none:
            biometricsImageView.image = nil
            self.biometricsType = "Not Available"
        case .touchID:
            biometricsImageView.image = #imageLiteral(resourceName: "touchId")
            self.biometricsType = "Touch ID"
        case .faceID:
            biometricsImageView.image = #imageLiteral(resourceName: "faceId")
            self.biometricsType = "Face ID"
        }
        if !self.bioAuth.canEvaluatePolicy() {
            self.enableButton.isEnabled = false
            UIAlertController.alert("", message: "Please configure your settings to enable this feature.").show()
        }
        enableButton.setTitle("Enable \(self.biometricsType)", for: .normal)
        contentTextView.text = "Your \(self.biometricsType) will be enabeled on this device and any \(self.biometricsType) saved on this device will have same access rights, that will help you to hassle free access into the app."
    }
    
}
