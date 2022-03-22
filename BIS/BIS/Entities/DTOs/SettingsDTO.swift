//
//  SettingsDTO.swift
//  BIS
//
//  Created by TSSIOS on 12/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

struct SettingsDTO {
    var heading: String?
    var items: [SettingsItemDTO]? = []
}

extension SettingsDTO {
    init(json: [String: Any]) {
        self.heading = json["heading"] as? String
        self.items = (json["items"] as? [[String: Any]])?.enumerated().map { (_, obj) in SettingsItemDTO.init(json: obj) }
    }
}

struct SettingsItemDTO {
    var title: String?
    var status: Bool?
    var value: String?
}

extension SettingsItemDTO {
    init(json: [String: Any]) {
        self.title = json["settingTitle"] as? String
        self.value = json["value"] as? String
        self.status = json["status"] as? Bool
    }
}
