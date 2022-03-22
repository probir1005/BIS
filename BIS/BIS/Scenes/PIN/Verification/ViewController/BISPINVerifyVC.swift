//
//  BISPINVerifyVC.swift
//  BIS
//
//  Created by TSSIOS on 13/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import AVFoundation
import AudioToolbox
import LocalAuthentication
import UIKit

protocol PINVerifyVCProtocol: class {
    var onFinish: (() -> Void)? { get set }
    var onForgotPIN: (() -> Void)? { get set }
    var onMaxAttempt: (() -> Void)? { get set }
    var presenter: PINVerifyPresenterProtocol? { get set }
    var interactor: PINVerifyInteractorProtocol? { get set }

    // Update UI with value returned.
    func set(errorMessage: String)
    func setInitialView(pin: String)
    func set(pinNumber: Int)
    func pinVerified()
}

class BISPINVerifyVC: BaseViewController, PINVerifyVCProtocol {

    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var keyboard: NumericKeyboard!
    @IBOutlet weak var codeView: CodeView!

    var codeArray = [Int]()
    var onFinish: (() -> Void)?
    var onForgotPIN: (() -> Void)?
    var onMaxAttempt: (() -> Void)?
    var presenter: PINVerifyPresenterProtocol?
    var interactor: PINVerifyInteractorProtocol?
    var pinToValidate: String!
    let bioAuth = BiometricAuthentication()
    var biometricsEnableStatus: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.biometricsEnableStatus = UserDefaultsService().getBool(key: .enableBio)
        self.interactor?.fetchPIN()
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
        object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.biometricsEnableStatus {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                self.authenticate()
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        self.resetTrialCount()
    }

    @objc func willEnterForeground() {
        self.authenticate()
    }

    private func resetTrialCount() {
        if UserDefaultsService().getInt(key: .wrongPINTrialCount) > 0 {
            if Date().getLocalDate() > UserDefaultsService().getDate(key: .wrongPINTrialTime).addingTimeInterval(1800).getLocalDate() {
                UserDefaults.setVal(value: 0, forKey: .wrongPINTrialCount)
            }
        }

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
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.onFinish?()
                }
            }
        })
    }
}

extension BISPINVerifyVC: CustomKeyBoardProtocol {

    // MARK: View Setup and Update
    func setInitialView(pin: String) {
        self.pinToValidate = pin
        self.keyboard.keyboardDelegate = self
        self.keyboard.rightButtonInput = self.bioAuth.biometricType != .none && self.codeArray.isEmpty && self.biometricsEnableStatus ? self.bioAuth.biometricType == .touchID ? .finger : .face : .erase
        self.keyboard.leftButtonInput = .forgot
        self.alertLabel.isHidden = true
        self.screenTitleLabel.text = "Please Enter PIN"
        self.alertLabel.text = ""
    }

    func set(errorMessage: String) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        codeView.shakeOnXAxis()
        self.alertLabel.isHidden = false
        codeView.resetStarView()
        self.screenTitleLabel.text = "Please Enter PIN"
        self.alertLabel.text = errorMessage
        UserDefaults.setVal(value: UserDefaultsService().getInt(key: .wrongPINTrialCount) + 1, forKey: .wrongPINTrialCount)
        if UserDefaultsService().getInt(key: .wrongPINTrialCount) > 2 {
            UIAlertController.alert("", message: "Your have exceeded the maximum number of trial.", cancelActionTitle: nil, destructiveActionTitle: nil, okAction: { _ in
                self.onMaxAttempt?()
                }, cancelAction: nil, destructiveAction: nil).show()
        } else if UserDefaultsService().getInt(key: .wrongPINTrialCount) == 1 {
            UserDefaults.setVal(value: Date(), forKey: .wrongPINTrialTime)
        }
    }

    func set(pinNumber: Int) {
        codeArray.append(pinNumber)
        codeView.starViewHidden(tag: codeArray.count - 1)
        if codeArray.count == 6 {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.interactor?.verifyPIN(pinNum: (self.codeArray.map { String($0) }.joined()))
                self.codeArray.removeAll()
            }
        }
        self.alertLabel.text = ""
    }

    func pinVerified() {
        self.onFinish?()
    }

    // MARK: - Keyboard Delegate Method
    func buttonClickAtNumber(index: Int) {
        if index == 100 {
            switch self.keyboard.rightButtonInput {
            case .erase:
                if !codeArray.isEmpty {
                    codeView.starViewHidden(tag: codeArray.count - 1)
                    codeArray.removeLast()
                    self.keyboard.rightButtonInput = self.bioAuth.biometricType != .none && self.codeArray.isEmpty && self.biometricsEnableStatus ? self.bioAuth.biometricType == .touchID ? .finger : .face : .erase
                }
            case .finger, .face: self.authenticate()
            default:
                break
            }
            return
        } else if index == 101 {
            UIAlertController.alert("", message: "Do you want to reset your PIN?Please login to create new PIN", cancelActionTitle: "Cancel", destructiveActionTitle: "Yes", okAction: nil, cancelAction: nil) { _ in
                self.onForgotPIN?()
            }.show()
            return
        }
        self.keyboard.rightButtonInput = .erase
        self.interactor?.updatePIN(pinNumber: index)
    }
}
