//
//  BISSignInAPIWorker.swift
//  BIS
//
//  Created by TSSIOS on 30/07/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

protocol SignInAPIWorkerProtocol {
    func fetchOTP(userName: String, password: String, callBack: @escaping (OtpDTO?, Error?) -> Void)
}

class BISSignInAPIWorker: SignInAPIWorkerProtocol {
    var networkingManager = NetworkingManager()

    func fetchOTP(userName: String, password: String, callBack: @escaping (OtpDTO?, Error?) -> Void) {

        self.networkingManager.signInUser(username: userName, password: password) { (otp, error)  in
            callBack(otp, error)
        }
    }
}
