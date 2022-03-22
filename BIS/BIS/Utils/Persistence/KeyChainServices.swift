//
//  KeyChainServices.swift
//  BIS
//
//  Created by TSSIOS on 13/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation
import KeychainSwift

protocol KeychainServices {
    func set(_ key: KaychainKey, value: String)
    func get(_ key: KaychainKey) -> String?
    func clear()
}

enum KaychainKey: String {
    case accessToken = "Access_Token"
    case accessRefreshToken = "Access_Refresh_Token"
    case appLockPIN = "App_Lock_PIN"
}

class KeyChainService: KeychainServices {

    private let keychain = KeychainSwift()

    func set(_ key: KaychainKey, value: String) {
        keychain.set(value, forKey: key.rawValue)
    }

    func get(_ key: KaychainKey) -> String? {
        return keychain.get(key.rawValue)
    }

    func clear() {
        keychain.clear()
    }
}
