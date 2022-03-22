//
//  OpenAPI.swift
//  BIS
//
//  Created by TSSIOS on 26/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Alamofire
import Foundation
import Moya

enum OpenAPI {
    case userSignIn(username: String, password: String)
    case verifyOTP(username: String, otp: Int)
}

extension OpenAPI: TargetType {
    var baseURL: URL {
        return Configuration.environment.apiUrl
    }

    var path: String {
        switch self {
        case .userSignIn:
            return "/authenticateotp"
        case .verifyOTP:
            return "/otp/validate"

        }
    }

    var method: Moya.Method {
        switch self {
        case .userSignIn, .verifyOTP:
            return .post
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .userSignIn(let username, let password):
            let params = ["username": username, "password": password]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .verifyOTP(let username, let otp):
            let params = ["username": username, "otp": otp] as [String : Any]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }

    }

    var headers: [String: String]? {
        return [
            "Content-Type": "application/json"
        ]
    }
}
