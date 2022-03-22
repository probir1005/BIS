//
//  BISSignInVC.swift
//  BIS
//
//  Created by TSSIOS on 15/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

protocol SignInVCProtocol: class {
    var onSignIn: (() -> Void)? { get set }
    var onTAndC: (() -> Void)? { get set }
    var onPrivacyPolicy: (() -> Void)? { get set }
    var onHelp: (() -> Void)? { get set }
    var presenter: SignInPresenterProtocol? { get set }
    var interactor: SignInInteractorProtocol? { get set }

    // Update UI with value returned.
    func set(errorMessage: String)
    func confirmSignIn(dto: OtpDTO)
    func setEyeView(selected: Bool)
    func setCheckBoxView(selected: Bool)
}

class BISSignInVC: BaseViewController, SignInVCProtocol {

    var presenter: SignInPresenterProtocol?
    var interactor: SignInInteractorProtocol?

    var onSignIn: (() -> Void)?
    var onTAndC: (() -> Void)?
    var onPrivacyPolicy: (() -> Void)?
    var onHelp: (() -> Void)?

    // MARK: - Outlets and properties:
    @IBOutlet weak var userIdView: MaterialInputView!
    @IBOutlet weak var passwordView: MaterialInputView!
    @IBOutlet weak var userIdErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var loginButton: PrimaryButton!
    @IBOutlet weak var termsConditionsLabel: UILabel!
    @IBOutlet weak var termsCheckButton: UIButton!
    @IBOutlet weak var eyeButton: UIButton!
    static var agreementText = "I accept the T&C and Privacy Policy."
    
    // MARK: - View Controller life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.clearAllFields()
    }
    
    // MARK: - Private methods

    private func initializeView() {
        self.loginButton.isEnabled = false
        self.shouldDismissKeyboardOnViewTap = true
        userIdView.textField.returnKeyType = .next
        passwordView.textField.returnKeyType = .done
        userIdView.labelText = "User ID"
        userIdView.textFieldDelegate = self
        passwordView.labelText = "Password"
        passwordView.textFieldDelegate = self
        userIdView.textField.enablesReturnKeyAutomatically = true
        passwordView.textField.enablesReturnKeyAutomatically = true
        passwordView.textField.textContentType = .newPassword
//        passwordView.textField.isSecureTextEntry = !eyeButton.isSelected
        
        let termsText = BISSignInVC.agreementText
        let termsAttributedText = NSMutableAttributedString.init(string: termsText, attributes: [.font: BISFont.bodyText.regular,
             .foregroundColor: UIColor.darkGray2])
        
        if let range = termsText.range(of: "T&C") {
            termsAttributedText.addAttributes([.font: BISFont.bodyText.semibold,
                                               .foregroundColor: UIColor.dodgerBlueDark],
                                              range: NSRange.init(range, in: termsText))
        }
        
        if let range = termsText.range(of: "Privacy Policy") {
            termsAttributedText.addAttributes([.font: BISFont.bodyText.semibold,
                                               .foregroundColor: UIColor.dodgerBlueDark],
                                              range: NSRange.init(range, in: termsText))
        }
        
        termsConditionsLabel.attributedText = termsAttributedText
        termsConditionsLabel.isUserInteractionEnabled = true
        termsConditionsLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapLabel(gesture:))))
        shouldDismissKeyboardOnViewTap = true
    }

    override func dismissKeyboard() {
        self.loginButton.isEnabled = self.isUserInfoValid()
        self.view.endEditing(true)
    }

    @objc func tapLabel(gesture: UITapGestureRecognizer) {

        let termsRange = (BISSignInVC.agreementText as NSString).range(of: "T&C")
        let privacyRange = (BISSignInVC.agreementText as NSString).range(of: "Privacy Policy")
        let tapLocation = gesture.location(in: termsConditionsLabel)
        let index = termsConditionsLabel.indexOfAttributedTextCharacterAtPoint(point: tapLocation)

        if index > termsRange.location && index < termsRange.location + termsRange.length {
            self.onTAndC?()
        } else if index > privacyRange.location && index < privacyRange.location + privacyRange.length {
            self.onPrivacyPolicy?()
        }
    }

    // This method is temparory.
    private func isUserInfoValid() -> Bool {

        var validInfo = false
        self.userIdErrorLabel.text = ""
        self.passwordErrorLabel.text = ""

        if userIdView.textField.text?.isEmpty ?? true {
            userIdErrorLabel.text = "*Please enter username."
        } else if !(userIdView.textField.text?.isValidUserName() ?? false) {
            userIdErrorLabel.text = "*Please enter a valid username."
        } else if (!(userIdView.textField.text?.isEmpty ?? true) && (userIdView.textField.text?.isValidUserName() ?? false)) &&  passwordView.textField.text?.isEmpty ?? true {

            passwordErrorLabel.text = "*Please enter password."
        } else if !(passwordView.textField.text?.isEmpty ?? true) &&  !(passwordView.textField.text?.isValidPassword() ?? false) {
            self.userIdErrorLabel.text = ""
            passwordErrorLabel.text = "*Please enter a valid password."
        } else if (userIdView.textField.text?.isValidUserName() ?? false) && (passwordView.textField.text?.isValidPassword() ?? false) && self.termsCheckButton.isSelected {
            self.userIdErrorLabel.text = ""
            self.passwordErrorLabel.text = ""
            validInfo = true
        }

        return validInfo
    }
    
    private func clearAllFields() {
        userIdErrorLabel.text = ""
        passwordErrorLabel.text = ""
        userIdView.textField.text = ""
        passwordView.textField.text = ""
        self.termsCheckButton.isSelected = false
        self.loginButton.isEnabled = false
        self.eyeButton.isSelected = false
        self.passwordView.textField.isSecureTextEntry = !eyeButton.isSelected
        self.userIdView.textField.becomeFirstResponder()
    }
    
    // MARK: - Button Action Methods
    @IBAction func checkButtonTapped(_ sender: UIButton) {
        self.interactor?.updateCheckBox(isSelected: !sender.isSelected)
//        sender.isSelected = !sender.isSelected
//        self.loginButton.isEnabled = self.isUserInfoValid()
//        self.view.endEditing(true)
    }
    
    @IBAction func eyeButtonTapped(_ sender: UIButton) {
        self.interactor?.updateEye(isSelected: !sender.isSelected)
//        self.view.endEditing(true)
//        sender.isSelected = !sender.isSelected
//        passwordView.textField.isSecureTextEntry = !sender.isSelected
    }
    
    @IBAction func signinButtonTapped(_ sender: Any) {
        self.interactor?.fetchUser(userName: userIdView.textField.text!, password: passwordView.textField.text!)
    }
    
    @IBAction func helpButtonTapped(_ sender: Any) {
        onHelp?()
    }

    func setEyeView(selected: Bool) {
        self.view.endEditing(true)
        self.eyeButton.isSelected = selected
        self.passwordView.textField.isSecureTextEntry = !selected
    }

    func setCheckBoxView(selected: Bool) {
        self.termsCheckButton.isSelected = selected
        self.loginButton.isEnabled = self.isUserInfoValid()
        self.view.endEditing(true)
    }

    func set(errorMessage: String) {
        UIAlertController.alert("", message: errorMessage).show()
    }

    func confirmSignIn(dto: OtpDTO) {
        UIAlertController.alert("", message: "An OTP has been sent to this registered email  \(dto.email)", cancelActionTitle: nil, destructiveActionTitle: nil, okAction: { _ in
            self.onSignIn?()
            }, cancelAction: nil, destructiveAction: nil).show()
    }
}

extension BISSignInVC: MaterialTextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) {
        if textField.returnKeyType == .next {
            if textField.text?.isEmpty ?? false {
                userIdErrorLabel.text = "*Please enter username."
            } else if !(textField.text?.isValidUserName() ?? false) {
                userIdErrorLabel.text = "*Please enter a valid username."
            } else {
                passwordView.textField.becomeFirstResponder()
            }
        } else {
            if textField.text?.isEmpty ?? false {
                passwordErrorLabel.text = "*Please enter password."
            } else if !(textField.text?.isValidPassword() ?? false) {
                passwordErrorLabel.text = "*Please enter a valid password."
            } else {
                view.endEditing(true)
            }
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.loginButton.isEnabled = self.isUserInfoValid()
    }

    func textFieldDidChangeCharacter(_ textField: UITextField, range: NSRange, string: String) -> Bool {
        let maxLength = 20
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if (self.userIdView.textField.text?.isValidUserName() ?? false) && (self.passwordView.textField.text?.isValidPassword() ?? false) && self.termsCheckButton.isSelected {
                self.loginButton.isEnabled = true
            } else {
                self.loginButton.isEnabled = false
            }
        }
        return newString.length <= maxLength
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == passwordView.textField && self.userIdView.textField.text?.trimmed.isEmpty ?? false {
            self.userIdErrorLabel.text = "*Please enter username."
            self.passwordErrorLabel.text = ""
        } else if textField == passwordView.textField && !(self.userIdView.textField.text?.trimmed.isEmpty ?? false) && !(self.userIdView.textField.text?.isValidUserName() ?? false) {
            self.userIdErrorLabel.text = "*Please enter a valid username."
            self.passwordErrorLabel.text = ""
        }

        if textField == userIdView.textField && !(userIdErrorLabel.text?.isEmpty ?? true) {
            self.userIdErrorLabel.text = ""
        }

        if textField == passwordView.textField && !(passwordErrorLabel.text?.isEmpty ?? true) {
            self.passwordErrorLabel.text = ""
        }

    }
}
