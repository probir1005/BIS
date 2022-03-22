//
//  UserDefaults+AddOns.swift
//  BIS
//
//  Created by TSSIOS on 17/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation

enum UserDefaultsKey: String {
    case notification = "In_App_Notification"
    case enablePIN = "Enable_PIN"
    case enableBio = "Enable_Biometrics"
    case enableAssistiveZoom = "Enable_Assistive_Zoom"
    case userInfo = "User_Info"
    case otpInfo = "Otp_Info"
    case backgroundTime = "Background_Time"
    case wrongPINTrialCount = "Wrong_PIN_Trial_Count"
    case wrongPINTrialTime = "Wrong_PIN_Trial_Time"
}

extension UserDefaults {

    private static let defaults = UserDefaults.standard

    class func setVal<Element: Codable>(value: Element, forKey key: UserDefaultsKey) {
        let data = try? JSONEncoder().encode(value)
        defaults.setValue(data, forKey: key.rawValue)
    }

    class func getVal<Element: Codable>(forKey key: UserDefaultsKey) -> Element? {
        guard let data = defaults.data(forKey: key.rawValue) else { return nil }
        let element = try? JSONDecoder().decode(Element.self, from: data)
        return element
    }

    class func setVal<Element: Codable>(value: Element, for key: String) {
        let data = try? JSONEncoder().encode(value)
        defaults.setValue(data, forKey: key)
    }

    class func getVal<Element: Codable>(for key: String) -> Element? {
        guard let data = defaults.data(forKey: key) else { return nil }
        let element = try? JSONDecoder().decode(Element.self, from: data)
        return element
    }
    
    class func remove(_ key: UserDefaultsKey) {
        defaults.removeObject(forKey: key.rawValue)
    }

    class func remove(_ key: String) {
        defaults.removeObject(forKey: key)
    }
    
    class func reset() {
        let domainName = Bundle.main.bundleIdentifier!
        defaults.removePersistentDomain(forName: domainName)
        UserDefaults.standard.synchronize()
    }

}
