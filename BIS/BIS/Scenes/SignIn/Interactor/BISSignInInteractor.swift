//
//  BISSignInInteractor.swift
//  BIS
//
//  Created by TSSIOS on 30/07/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

/// Candy Module Interactor Protocol
protocol SignInInteractorProtocol {
    // Fetch User
    func fetchUser(userName: String, password: String)
    func updateCheckBox(isSelected: Bool)
    func updateEye(isSelected: Bool)
}

class BISSignInInteractor: SignInInteractorProtocol {

    private let apiWorker: SignInAPIWorkerProtocol
    var presenter: SignInPresenterProtocol?

    required init(withApiWorker apiWorker: SignInAPIWorkerProtocol) {
        self.apiWorker = apiWorker
    }

    func fetchUser(userName: String, password: String) {
        self.apiWorker.fetchOTP(userName: userName, password: password) { (otp, error) in
            if otp != nil {
                self.presenter?.interactor(self, didFetch: otp!)
            } else {
                self.presenter?.interactor(self, didFailWith: error!)
            }
        }
    }

    func updateCheckBox(isSelected: Bool) {
        self.presenter?.interactor(self, didUpdateCheckBoxWith: isSelected)
    }

    func updateEye(isSelected: Bool) {
        self.presenter?.interactor(self, didUpdateEyeWith: isSelected)
    }

}
