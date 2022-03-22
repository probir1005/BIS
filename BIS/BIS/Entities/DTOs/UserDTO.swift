//
//  UserDTO.swift
//  BIS
//
//  Created by TSSIOS on 17/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation

struct UserDTO: Codable {

    let accessToken: String
    let firstName: String
    let lastName: String?
    let dashboardList: [String]
    let reportList: [String]

    enum CodingKeys: String, CodingKey {
        case accessToken = "token"
        case firstName = "firstName"
        case lastName = "lastName"
        case dashboardList = "dashboard"
        case reportList = "reports"
    }

    static func userFromData(data: Data) -> UserDTO? {
        let decoder = JSONDecoder()
        do {
            let session = try decoder.decode(UserDTO.self, from: data)
            return session
        } catch {
            print("Can't decode Session: \(error)")
        }
        return nil
    }

    init(user: User) {
        self.accessToken = user.accessToken
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.dashboardList = user.dashboardList ?? []
        self.reportList = user.reportsList ?? []
    }
}
