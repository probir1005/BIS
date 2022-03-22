//
//  JSON+Codable.swift
//  BIS
//
//  Created by TSSIOS on 28/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation

extension Encodable {

    func toJsonString() throws -> String {
        let jsonEncoder = JSONEncoder()
        let jsonData = try jsonEncoder.encode(self)
        if let string = String(data: jsonData, encoding: .utf8) {
            return string
        } else {
            throw DebugError(message: "Could not make string from the data.")
        }
    }

    func toJsonStringResult() -> Result<String, Error> {
        return Result { try toJsonString() }
    }

}

extension Decodable {

    static func from(data: Data) throws -> Self {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = Date.dateDefaultDecoder
        return try decoder.decode(Self.self, from: data)
    }

    static func listFrom(data: Data) throws -> [Self] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = Date.dateDefaultDecoder
        return try decoder.decode([Self].self, from: data)
    }

    static func resultFrom(data: Data) -> Result<Self, Error> {
        return Result<Self, Error> { try from(data: data) }
    }

    static func from(jsonString: String) throws -> Self {
        guard let data = jsonString.data(using: .utf8) else {
            throw DebugError(message: "Could not serialize string.")
        }
        return try from(data: data)
    }

    static func resultFrom(jsonString: String) -> Result<Self, Error> {
        return Result<Self, Error> { try from(jsonString: jsonString) }
    }

}
