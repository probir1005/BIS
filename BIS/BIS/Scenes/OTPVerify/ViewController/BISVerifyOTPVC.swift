//
//  BISVerifyOTPVC.swift
//  BIS
//
//  Created by TSSIOS on 26/08/20.
//  Copyright © 2020 TSS. All rights reserved.
//

import UIKit

protocol VerifyOTPVCProtocol: class {
    var onVerify: (() -> Void)? { get set }
    var onResendOTP: (() -> Void)? { get set }
    var presenter: VerifyOTPPresenterProtocol? { get set }
    var interactor: VerifyOTPInteractorProtocol? { get set }

    // Update UI with value returned.
    func set(errorMessage: String)
    func confirmVerification()
    func setResendOTPView(dto: OtpDTO?)
    func setResendOTPViewWith(errorMessage: String)
}

class BISVerifyOTPVC: BaseViewController, VerifyOTPVCProtocol {

    var presenter: VerifyOTPPresenterProtocol?
    var interactor: VerifyOTPInteractorProtocol?

    var onVerify: (() -> Void)?
    var onResendOTP: (() -> Void)?

    // MARK: - Outlets and properties:
    @IBOutlet weak var otpView: MaterialInputView!
    @IBOutlet weak var otpErrorLabel: UILabel!
    @IBOutlet weak var verifyButton: PrimaryButton!
    @IBOutlet weak var resendOTPButton: UIButton!
    var gameTimer: Timer?
    var counter = 60
    var hasTimerOn: Bool = false

    // MARK: - View Controller life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Private methods

    private func initializeView() {
        let bar = UIToolbar()
        let doneButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        bar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneButtonItem]
        bar.sizeToFit()
        otpView.textField.inputAccessoryView = bar

        self.verifyButton.isEnabled = false
        self.shouldDismissKeyboardOnViewTap = true
        otpView.textField.returnKeyType = .done
        otpView.labelText = "Enter OTP"
        otpView.textFieldDelegate = self
        otpView.textField.enablesReturnKeyAutomatically = true
        otpView.textField.keyboardType = .numberPad
        otpView.textField.textContentType = .newPassword
        otpView.textField.isSecureTextEntry = true
        shouldDismissKeyboardOnViewTap = true
        resendOTPButton.isHidden = !hasTimerOn
    }

    @objc func doneTapped() {
        self.verifyButton.isEnabled = self.isOTPValid()
        self.view.endEditing(true)
    }

    override func dismissKeyboard() {
        self.verifyButton.isEnabled = self.isOTPValid()
        self.view.endEditing(true)
    }

    // This method is temparory.
    private func isOTPValid() -> Bool {

        var validInfo = false
        self.otpErrorLabel.text = ""
        if otpView.textField.text != nil && otpView.textField.text?.count == 6 {
            validInfo = true
        }

        return validInfo
    }

    // MARK: - Button Action Methods
    @IBAction func resendOTPButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        hasTimerOn = !hasTimerOn
        self.interactor?.resendOTP()
    }

    @IBAction func verifyButtonAction(_ sender: Any) {
        if let otpData = UserDefaultsService().getOTP(), otpView.textField.text != nil {
            self.resendOTPButton.isHidden = false
            self.interactor?.verifyOTP(userName: otpData.userName, otp: otpView.textField.text!)
        }
    }

    func setResendOTPView(dto: OtpDTO?) {
        self.view.endEditing(true)
        if hasTimerOn {
            UIAlertController.alert("", message: "An OTP has been sent to this registered email  \(dto?.email ?? "")").show()
            self.gameTimer?.invalidate()
            self.otpView.textField.text = ""
            self.resendOTPButton.isUserInteractionEnabled = false
            self.resendOTPButton.isEnabled = false
            self.resendOTPButton.setTitleColor(UIColor.lightGray3, for: .normal)
            self.resendOTPButton.setTitle("Resend After 1:00", for: .normal)
            self.gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startTimer), userInfo: nil, repeats: true)
        } else {
            self.resendOTPButton.setTitleColor(UIColor.dodgerBlueLight, for: .normal)
            self.resendOTPButton.setTitle("Resend OTP", for: .normal)
            self.resendOTPButton.isEnabled = true
            self.resendOTPButton.isUserInteractionEnabled = true
        }
    }

    @objc func startTimer() {
        if counter > 0 {
            counter -= 1
            self.resendOTPButton.setTitle(counter < 10 ? "Resend After 00:0\(counter)" : "Resend After 00:\(counter)", for: .normal)
        } else {
            self.gameTimer?.invalidate()
            self.counter = 60
            self.hasTimerOn = false
            self.setResendOTPView(dto: nil)
        }
    }

    func set(errorMessage: String) {
        self.otpView.textField.text = ""
        self.otpErrorLabel.text = "Please enter a valid OTP."
    }

    func setResendOTPViewWith(errorMessage: String) {
        UIAlertController.alert("", message: errorMessage).show()
    }

    func confirmVerification() {
        self.gameTimer?.invalidate()
        self.counter = 60
        self.onVerify?()
    }
}

extension BISVerifyOTPVC: MaterialTextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) {
        self.verifyButton.isEnabled = self.isOTPValid()
    }

    func textFieldDidChangeCharacter(_ textField: UITextField, range: NSRange, string: String) -> Bool {
        let maxLength = 6
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if newString.length == 6 {
                self.verifyButton.isEnabled = true
            } else {
                self.verifyButton.isEnabled = false
            }
        }
        return newString.length <= maxLength
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.verifyButton.isEnabled = self.isOTPValid()
    }
}
