//
//  BISVerifyOTPAPIWorker.swift
//  BIS
//
//  Created by TSSIOS on 27/08/20.
//  Copyright © 2020 TSS. All rights reserved.
//

import UIKit

protocol VerifyOTPAPIWorker {
    func fetchOTP(userName: String, password: String, callBack: @escaping (OtpDTO?, Error?) -> Void)
    func verifyOTP(userName: String, otp: String, callBack: @escaping (UserDTO?, Error?) -> Void)
}

class BISVerifyOTPAPIWorker: VerifyOTPAPIWorker {
    var networkingManager = NetworkingManager()

    func verifyOTP(userName: String, otp: String, callBack: @escaping (UserDTO?, Error?) -> Void) {

        self.networkingManager.verifyOTP(username: userName, otp: otp) { (user, error)  in
            callBack(user, error)
        }
    }

    func fetchOTP(userName: String, password: String, callBack: @escaping (OtpDTO?, Error?) -> Void) {

        self.networkingManager.signInUser(username: userName, password: password) { (otp, error)  in
            callBack(otp, error)
        }
    }
}
