//
//  BISPINRegisterVC.swift
//  BIS
//
//  Created by TSSIOS on 15/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import AVFoundation
import AudioToolbox
import UIKit

protocol PINRegisterVCProtocol: class {
    var onNextStep: ((_ pinNumber: String) -> Void)? { get set }
    var onError: (() -> Void)? { get set }
    var onFinish: (() -> Void)? { get set }
    var presenter: PINRegisterPresenterProtocol? { get set }
    var interactor: PINRegisterInteractorProtocol? { get set }

    // Update UI with value returned.
    func set(errorMessage: String)
    func set(pinNumber: Int)
    func set(confirmPIN: String)
    func setInitialView()
}

class BISPINRegisterVC: BaseViewController, PINRegisterVCProtocol {
    var presenter: PINRegisterPresenterProtocol?
    var interactor: PINRegisterInteractorProtocol?

    var onNextStep: ((_ pinNumber: String) -> Void)?
    var onError: (() -> Void)?
    var onFinish: (() -> Void)?
    var codeArray = [Int]()
    var pinToValidate: String!
    var appKeyChain = KeyChainService()

    @IBOutlet weak var keyboard: NumericKeyboard!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var screenInfoLabel: UILabel!
    @IBOutlet weak var codeView: CodeView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactor?.fetchPIN()
        self.keyboard.keyboardDelegate = self
        self.keyboard.rightButtonInput = .erase
    }
}

extension BISPINRegisterVC: CustomKeyBoardProtocol {
    static let starViewTagConstant = 5000

    // MARK: View Setup and Update
    func set(errorMessage: String) {
        self.alertLabel.isHidden = false
        self.screenTitleLabel.text = "Please Enter PIN"
        self.screenInfoLabel.text = "By Entering pin App will be secured from unknown user"
        self.alertLabel.text = "Second PIN was different than the first one. Please try this again"
    }

    func setInitialView() {
        self.alertLabel.isHidden = true
        self.screenTitleLabel.text = "Please Enter PIN"
        self.screenInfoLabel.text = "By Entering pin App will be secured from unknown user"
        self.alertLabel.text = ""
    }

    func set(confirmPIN: String) {
        self.pinToValidate = confirmPIN
        self.alertLabel.isHidden = true
        self.screenTitleLabel.text = "Please Re-Enter PIN To Confirm"
        self.screenInfoLabel.text = ""
        self.alertLabel.text = ""
    }

    func set(pinNumber: Int) {
        codeArray.append(pinNumber)
        codeView.starViewHidden(tag: codeArray.count - 1)
        if codeArray.count == 6 {
            let code = (codeArray.map { String($0) }.joined())
            if self.pinToValidate != nil && !self.pinToValidate.isEmpty && self.pinToValidate == code {
                appKeyChain.set(.appLockPIN, value: (codeArray.map { String($0) }.joined()))
                self.onFinish?()
            } else if self.pinToValidate != nil && !self.pinToValidate.isEmpty && self.pinToValidate != code {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                codeView.shakeOnXAxis()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.onError?()
                }
            }
            self.onNextStep?(codeArray.map { String($0) }.joined())
        }
        self.alertLabel.text = ""
    }

    // MARK: - Keyboard Delegate Method
    func buttonClickAtNumber(index: Int) {
        if index == 100 {
            if !codeArray.isEmpty {
                codeView.starViewHidden(tag: codeArray.count - 1)
                codeArray.removeLast()
            }
            return
        }
        self.interactor?.updatePIN(pinNumber: index)
    }

}
