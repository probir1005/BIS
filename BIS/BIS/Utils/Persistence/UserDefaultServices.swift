//
//  UserDefaultServices.swift
//  BIS
//
//  Created by TSSIOS on 29/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation

protocol UserDefaultsServicing {
    // User
    func set(user: UserDTO)
    func getOTP() -> OtpDTO?
    func getUser() -> UserDTO?
    func getInt(key: UserDefaultsKey) -> Int
    func getBool(key: UserDefaultsKey) -> Bool
    func getDate(key: UserDefaultsKey) -> Date
    func removeAll()
}

class UserDefaultsService: UserDefaultsServicing {

    private let semaphore = DispatchSemaphore(value: 1)

    // MARK: User Info

    func set(user: UserDTO) {
        semaphore.wait(); defer { semaphore.signal() }
        UserDefaults.setVal(value: user, forKey: .userInfo)
    }

    func set(otp: OtpDTO) {
        semaphore.wait(); defer { semaphore.signal() }
        UserDefaults.setVal(value: otp, forKey: .otpInfo)
    }

    func getUser() -> UserDTO? {
        semaphore.wait(); defer { semaphore.signal() }
        return UserDefaults.getVal(forKey: .userInfo)
    }

    func getOTP() -> OtpDTO? {
        semaphore.wait(); defer { semaphore.signal() }
        return UserDefaults.getVal(forKey: .otpInfo)
    }

    func removeAll() {
        let domainName = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domainName)
        UserDefaults.standard.synchronize()
    }

    func getInt(key: UserDefaultsKey) -> Int {
        semaphore.wait(); defer { semaphore.signal() }
        return UserDefaults.getVal(forKey: key) ?? 0
    }

    func getBool(key: UserDefaultsKey) -> Bool {
        semaphore.wait(); defer { semaphore.signal() }
        return UserDefaults.getVal(forKey: key) ?? false
    }

    func getDate(key: UserDefaultsKey) -> Date {
        semaphore.wait(); defer { semaphore.signal() }
        return UserDefaults.getVal(forKey: key) ?? Date()
    }

}
