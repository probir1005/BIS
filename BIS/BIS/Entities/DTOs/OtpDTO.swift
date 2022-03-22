//
//  OtpDTO.swift
//  BIS
//
//  Created by TSSIOS on 29/08/20.
//  Copyright © 2020 TSS. All rights reserved.
//

import Foundation

struct OtpDTO: Codable {

    let message: String
    let userName: String
    let email: String
    let status: String?

    enum CodingKeys: String, CodingKey {
        case message = "message"
        case userName = "username"
        case email = "email"
        case status = "status"

    }

    static func otpFromData(data: Data) -> OtpDTO? {
        let decoder = JSONDecoder()
        do {
            let session = try decoder.decode(OtpDTO.self, from: data)
            return session
        } catch {
            print("Can't decode Session: \(error)")
        }
        return nil
    }
}
