//
//  Dictionary+Json.swift
//  BIS
//
//  Created by TSSIOS on 27/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation

typealias Json = [String: Any]
typealias JsonArray = [Json]

enum JsonError: Error {
    case noData
    case couldNotParseAsJson
    case keyDoesNotExist(key: String)
    case objectTypeMismatch(key: String, expected: String)
    case arrayTypeMismatch(key: String)
    case valueTypeMismatch(key: String, expected: String, metatype: String)
    case couldNotSerializeToString
    case couldNotSerializeString
}

extension Dictionary where Key == String, Value == Any {

    // MARK: Getters and setters

    func get<Val>(_ key: String) throws -> Val {
        if let anyValue = self[key] {
            if let value = anyValue as? Val {
                return value
            } else {
                throw JsonError.valueTypeMismatch(
                    key: key,
                    expected: String(describing: Val.self),
                    metatype: String(describing: type(of: anyValue))
                )
            }
        } else {
            throw JsonError.keyDoesNotExist(key: key)
        }
    }

    func getObject<Val: JsonParsable>(_ key: String) throws -> Val {
        if let anyValue = self[key] {
            if let json = anyValue as? Json {
                return try Val.init(json: json)
            } else {
                throw JsonError.objectTypeMismatch(
                    key: key,
                    expected: String(describing: Val.self)
                )
            }
        } else {
            throw JsonError.keyDoesNotExist(key: key)
        }
    }

    func getArray<Val: JsonParsable>(
        _ key: String,
        willParse: ((Int, inout Json) -> Void)? = nil
    ) throws -> [Val] {
        if let anyValue = self[key] {
            if let jsonArray = anyValue as? JsonArray {
                var array = [Val]()
                if let willParse = willParse {
                    for (index, var json) in jsonArray.enumerated() {
                        willParse(index, &json)
                        array.append(try Val(json: json))
                    }
                } else {
                    for json in jsonArray {
                        array.append(try Val(json: json))
                    }
                }
                return array
            } else {
                throw JsonError.arrayTypeMismatch(key: key)
            }
        } else {
            throw JsonError.keyDoesNotExist(key: key)
        }
    }

    func getOptional<Val>(_ key: String) -> Val? {
        if let value = self[key] as? Val {
            return value
        } else {
            return nil
        }
    }

    func getObjectOptional<Val: JsonParsable>(_ key: String) throws -> Val? {
        if let anyValue = self[key] {
            if let json = anyValue as? Json {
                return try Val(json: json)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

    func getArrayOptional<Val: JsonParsable>(_ key: String) -> [Val]? {
        if let jsonArray = self[key] as? JsonArray {
            do {
                var array = [Val]()
                for json in jsonArray {
                    array.append(try Val(json: json))
                }
                return array
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }

    mutating func set<Val>(key: String, value: Val) {
        self[key] = value as Any
    }

    // MARK: Parse

    static func parse(_ data: Data) throws -> Json {
        let rawJson = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        if let json = rawJson as? Json {
            return json
        } else {
            throw JsonError.couldNotParseAsJson
        }
    }

    static func parseArray(_ data: Data) throws -> JsonArray {
        let rawJson = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        if let json = rawJson as? JsonArray {
            return json
        } else {
            throw JsonError.couldNotParseAsJson
        }
    }

    static func parseOptional(_ data: Data) -> Json? {
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Json {
                return json
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }

    static func parseArrayOptional(_ data: Data) -> JsonArray? {
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JsonArray {
                return json
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }

    static func parseModel<Model: JsonParsable>(
        _ data: Data,
        key: String? = nil,
        defaults: Json? = nil
    ) throws -> Model {
        var json: Json
        let jsonParsed = try Json.parse(data)
        if let key = key {
            json = try jsonParsed.get(key)
        } else {
            json = jsonParsed
        }
        if let defaults = defaults {
            json.merge(defaults, uniquingKeysWith: { a, _ in a })
        }
        return try Model(json: json)
    }

    static func parseModelOptional<Model: JsonParsable>(
        _ data: Data,
        key: String? = nil,
        defaults: Json? = nil
    ) -> Model? {
        do {
            var json: Json
            let jsonParsed = try Json.parse(data)
            if let key = key {
                json = try jsonParsed.get(key)
            } else {
                json = jsonParsed
            }
            if let defaults = defaults {
                json.merge(defaults, uniquingKeysWith: { a, _ in a })
            }
            return try Model(json: json)
        } catch {
            return nil
        }
    }

    static func parseArrayModel<Model: JsonParsable>(
        _ data: Data,
        key: String? = nil,
        defaults: Json? = nil
    ) throws -> [Model] {
        let jsonArray: JsonArray
        if let key = key {
            let json = try Json.parse(data)
            jsonArray = try json.get(key)
        } else {
            jsonArray = try Json.parseArray(data)
        }
        var modelArray = [Model]()
        if let defaults = defaults {
            for json in jsonArray {
                var jsonCopy = json
                jsonCopy.merge(defaults, uniquingKeysWith: { a, _ in a })
                modelArray.append(try Model(json: jsonCopy))
            }
        } else {
            for json in jsonArray {
                modelArray.append(try Model(json: json))
            }
        }
        return modelArray
    }

    // MARK: Serialize

    func serialize() throws -> Data {
        return try JSONSerialization.data(withJSONObject: self, options: [])
    }

    func serializeOptional() -> Data? {
        do {
            return try JSONSerialization.data(withJSONObject: self, options: [])
        } catch {
            return nil
        }
    }

    // MARK: Strings

    func toString() throws -> String {
        let jsonData = try self.serialize()
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        } else {
            throw JsonError.couldNotSerializeToString
        }
    }

    func toStringOptional() -> String? {
        if let jsonData = self.serializeOptional(),
            let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        }
        return nil
    }

    static func parse(string: String) throws -> Json {
        guard let data = string.data(using: .utf8) else {
            throw JsonError.couldNotSerializeString
        }
        return try Json.parse(data)
    }

    static func parseOptional(string: String) -> Json? {
        if let data = string.data(using: .utf8),
            let json = Json.parseOptional(data) {
            return json
        }
        return nil
    }

    static func parseArray(string: String) throws -> JsonArray {
        guard let data = string.data(using: .utf8) else {
            throw JsonError.couldNotSerializeString
        }
        return try Json.parseArray(data)
    }

    static func parseArrayOptional(string: String) -> JsonArray? {
        if let data = string.data(using: .utf8),
            let jsonArray = Json.parseArrayOptional(data) {
            return jsonArray
        }
        return nil
    }

}

extension Array where Element == Json {

    // MARK: Serialize

    func serialize() throws -> Data {
        return try JSONSerialization.data(withJSONObject: self, options: [])
    }

    func serializeOptional() -> Data? {
        do {
            return try JSONSerialization.data(withJSONObject: self, options: [])
        } catch {
            return nil
        }
    }

    // MARK: Strings

    func toString() throws -> String {
        let jsonData = try self.serialize()
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        } else {
            throw JsonError.couldNotSerializeToString
        }
    }

    func toStringOptional() -> String? {
        if let jsonData = self.serializeOptional(),
            let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        }
        return nil
    }

}
