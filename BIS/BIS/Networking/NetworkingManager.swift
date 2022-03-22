//
//  NetworkingManager.swift
//  BIS
//
//  Created by TSSIOS on 26/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation

class NetworkingManager {

    init() { }

    let networkingAgent = NetworkingHandler()
    let keychain = KeyChainService()

    func signInUser(username: String, password: String, completion: @escaping (OtpDTO?, Error?) -> Void) {
        if !self.networkingAgent.isReachable {
            completion(nil, DebugError(message: "Internet is not reachable. Please try again later."))
        }
        CustomNavigationController.appDelegate.InitializeIndicatorView(message: "Wait...")
        self.networkingAgent.request(.userSignIn(username: username, password: password)) { response in
            switch response {
            case .success(let data):
                guard let otp = OtpDTO.otpFromData(data: data) else {
                    IndicatorView.dismiss()
                    completion(nil, DebugError(message: "Unable to get otp."))
                    return
                }
                    UserDefaultsService().set(otp: otp)
                    IndicatorView.dismiss()
                    completion(otp, nil)
            case .failure(let error):
                IndicatorView.dismiss()
                completion(nil, error)
            }
        }
    }

    func verifyOTP(username: String, otp: String, completion: @escaping (UserDTO?, Error?) -> Void) {
        if !self.networkingAgent.isReachable {
            completion(nil, DebugError(message: "Internet is not reachable. Please try again later."))
        }
        CustomNavigationController.appDelegate.InitializeIndicatorView(message: "Wait...")
        self.networkingAgent.request(.verifyOTP(username: username, otp: Int(otp)!)) { response in
            switch response {
            case .success(let data):
                guard let user = UserDTO.userFromData(data: data) else {
                    IndicatorView.dismiss()
                    completion(nil, DebugError(message: "Unable to create user"))
                    return
                }
                    let accessToken = user.accessToken
                    self.keychain.set(.accessToken, value: accessToken)
                    IndicatorView.dismiss()
                    completion(user, nil)
            case .failure(let error):
                IndicatorView.dismiss()
                completion(nil, error)
            }
        }
    }
}
