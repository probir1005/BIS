//
//  NetworkingConfiguration.swift
//  BIS
//
//  Created by TSSIOS on 26/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation

enum Environment: String {

    case debug = "Debug"
    case stage = "Stage"
    case release = "Release"

    func getBaseURL() -> String {
        switch self {
        case .debug:
            return "https://dev.tss-digital.com/dev/v1"
        case .stage:
            return "https://dev.tss-digital.com/dev/v1"
        case .release:
            return "https://dev.tss-digital.com/dev/v1"
        }
    }

    init?(name: String?) {
        guard let safeName = name else { return nil }
        self.init(rawValue: safeName)
    }

    var apiUrl: URL {
        let baseUrl = getBaseURL()
        return URL(string: baseUrl)!
    }

}

func print(_ items: Any...) {
    #if DEBUG
    items.forEach { item in
        Swift.print(item)
    }
    #endif
}

class Configuration {

    static var environment: Environment = {
        return Environment(name: Bundle.main.object(forInfoDictionaryKey: "Configuration") as? String) ?? .debug
    }()

}
