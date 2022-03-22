//
//  BISVerifyOTPInteractor.swift
//  BIS
//
//  Created by TSSIOS on 26/08/20.
//  Copyright © 2020 TSS. All rights reserved.
//

import UIKit

/// Candy Module Interactor Protocol
protocol VerifyOTPInteractorProtocol {
    // Fetch User
    func verifyOTP(userName: String, otp: String)
    func resendOTP()
}

class BISVerifyOTPInteractor: VerifyOTPInteractorProtocol {

    private let apiWorker: VerifyOTPAPIWorker
    private let dbWorker: VerifyOTPDBWorker
    var presenter: VerifyOTPPresenterProtocol?

    required init(withApiWorker apiWorker: VerifyOTPAPIWorker, withDBWorker dbWorker: VerifyOTPDBWorker) {
        self.apiWorker = apiWorker
        self.dbWorker = dbWorker
    }

    func verifyOTP(userName: String, otp: String) {

        self.apiWorker.verifyOTP(userName: userName, otp: otp) { (userObj, error) in
            if userObj != nil {
                self.dbWorker.saveUser(userDTO: userObj!) { success in
                    if success {
                        self.presenter?.interactor(self, didVerify: userObj!)
                    } else {
                        self.presenter?.interactor(self, didFailWith: DebugError(message: "Failed to save into DB."))
                    }
                }
            } else {
                self.presenter?.interactor(self, didFailWith: error!)
            }
        }
    }

    func resendOTP() {
        if let otpData = UserDefaultsService().getOTP() {
            self.apiWorker.fetchOTP(userName: otpData.userName, password: "TestDemo@123") { (otp, error) in
                if otp != nil {
                    self.presenter?.interactor(self, didUpdateResendOTPWith: otp!)
                } else {
                    self.presenter?.interactor(self, didUpdateResendOTPWithError: error!)
                }

            }
        }

    }
}
