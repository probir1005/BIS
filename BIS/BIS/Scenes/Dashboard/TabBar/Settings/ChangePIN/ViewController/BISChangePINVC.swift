//
//  BISChangePINVC.swift
//  BIS
//
//  Created by TSSIOS on 12/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import AVFoundation
import AudioToolbox
import UIKit

protocol ChangePINVCProtocol: class {
    var onNewPIN: (() -> Void)? { get set }
    var onNextStep: ((_ pinNumber: String) -> Void)? { get set }
    var onError: (() -> Void)? { get set }
    var onFinish: (() -> Void)? { get set }
    var presenter: ChangePINPresenterProtocol? { get set }
    var interactor: ChangePINInteractorProtocol? { get set }

    // Update UI with value returned.
    func set(errorMessage: String)
    func setVerifyFail(errorMessage: String)
    func set(pinNumber: Int)
    func set(confirmPIN: String)
    func setInitialView(savedPIN: String)
    func setNewPINView()
    func pinVerified()
    func pinConfirmed(pin: String)
    func pinConfirmedFailed()
}

class BISChangePINVC: BaseViewController, ChangePINVCProtocol {
    var presenter: ChangePINPresenterProtocol?
    var interactor: ChangePINInteractorProtocol?

    var onNextStep: ((_ pinNumber: String) -> Void)?
    var onNewPIN: (() -> Void)?
    var onError: (() -> Void)?
    var onFinish: (() -> Void)?
    var codeArray = [Int]()
    var pinToValidate: String!
    var savedPIN: String!
    var appKeyChain = KeyChainService()

    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var settingsButton: UIButton!
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
        self.navBarView.heightConstraint?.constant = CustomNavigationController.appDelegate.landscape ? 0 : UIView.hasSafeArea ? 103 : 64

        self.setNavigationBarView(color: CustomNavigationController.appDelegate.landscape ? UIColor.dodgerBlueLight : UIColor.white)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customTabBarController()?.hideTabBar(isHide: true)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            // This is called during the animation
            self.orientationChange()
        }, completion: nil)
    }

    private func orientationChange() {
        var color = UIColor.white
            switch UIDevice.current.orientation {
            case .landscapeLeft, .landscapeRight, .portraitUpsideDown, .faceUp, .faceDown:
                color = UIColor.dodgerBlueLight
                self.navBarView.heightConstraint?.constant = 0
            case .portrait, .unknown:
                color = UIColor.white
                self.navBarView.heightConstraint?.constant = UIView.hasSafeArea ? 103 : 64
            default: break
            }
        self.setNavigationBarView(color: color)
    }

    func setNavigationBarView(color: UIColor) {

        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: .curveEaseInOut, animations: { [weak self] in
            self?.settingsButton.tintColor = color
            self?.settingsButton.imageView?.tintColor = color
            self?.settingsButton.setTitleColor(color, for: .normal)
            self?.navBarView.layoutIfNeeded()
            }, completion: { _ in

        })
    }

    @IBAction func settingsButtonAction(_ sender: UIButton) {
        self.onFinish?()
    }
    
}

extension BISChangePINVC: CustomKeyBoardProtocol {
    static let starViewTagConstant = 5000

    // MARK: View Setup and Update
    func set(errorMessage: String) {
        codeView.resetStarView()
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        codeView.shakeOnXAxis()
        self.alertLabel.isHidden = false
        self.screenTitleLabel.text = "Please Enter New PIN"
        self.screenInfoLabel.text = ""
        self.alertLabel.text = errorMessage
    }

    func setVerifyFail(errorMessage: String) {
        codeView.resetStarView()
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        codeView.shakeOnXAxis()
        self.alertLabel.isHidden = false
        self.screenTitleLabel.text = "Please Enter Current PIN"
        self.screenInfoLabel.text = ""
        self.alertLabel.text = errorMessage
    }

    func setInitialView(savedPIN: String) {
        self.savedPIN = savedPIN
        self.alertLabel.isHidden = true
        self.screenTitleLabel.text = "Please Enter Current PIN"
        self.screenInfoLabel.text = ""
        self.alertLabel.text = ""
    }

    func setNewPINView() {
        self.alertLabel.isHidden = true
        self.screenTitleLabel.text = "Please Enter New PIN"
        self.screenInfoLabel.text = ""
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

            if self.savedPIN == nil && self.pinToValidate == nil {
                guard let oldPIN = appKeyChain.get(.appLockPIN) else {
                    return
                }
                if oldPIN == (codeArray.map { String($0) }.joined()) {
                    codeView.resetStarView()
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                    codeView.shakeOnXAxis()
                    self.alertLabel.isHidden = false
                    self.alertLabel.text = "New PIN cannot be same as old PIN."
                } else {
                    self.onNextStep?(codeArray.map { String($0) }.joined())
                }
            } else {
                self.interactor?.verifyPIN(pinNum: (self.codeArray.map { String($0) }.joined()))
            }
            codeArray.removeAll()
            return
        }
        self.alertLabel.text = ""
    }

    func pinConfirmed(pin: String) {
        appKeyChain.set(.appLockPIN, value: pin)
        self.onFinish?()
    }

    func pinVerified() {
        self.onNewPIN?()
    }

    func pinConfirmedFailed() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        codeView.shakeOnXAxis()
        self.onError?()
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
