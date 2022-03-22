//
//  JSONHelper.swift
//  BIS
//
//  Created by TSSIOS on 28/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation

protocol JsonParsable {
    init(json: Json) throws
}

protocol JsonSerializable {
    func toJson() -> Json
}

typealias JsonModel = JsonParsable & JsonSerializable

extension Array where Element: JsonSerializable {

    func toJsonArray() -> JsonArray {
        return self.map { $0.toJson() }
    }

}
