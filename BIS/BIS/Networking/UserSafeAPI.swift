//
//  UserSafeAPI.swift
//  BIS
//
//  Created by TSSIOS on 26/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Alamofire
import Foundation
import Moya

enum UserSafeAPI {
    case getDashBoard
}

extension UserSafeAPI: TargetType {
    var baseURL: URL {
        return Configuration.environment.apiUrl
    }

    var path: String {
        switch self {
        case .getDashBoard:
            return ""

        }
    }

    var method: Moya.Method {
        return .post
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .getDashBoard:
            let params = ["": ""]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }

    var headers: [String: String]? {
        return [
            "Content-Type": "application/json"
        ]
    }
}
