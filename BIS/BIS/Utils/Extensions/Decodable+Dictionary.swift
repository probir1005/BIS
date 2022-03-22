//
//  Decodable+Dictionary.swift
//  BIS
//
//  Created by TSSIOS on 27/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation

extension Decodable {

    init(from value: Any,
         options: JSONSerialization.WritingOptions = [],
         decoder: JSONDecoder) throws {
        let data = try JSONSerialization.data(withJSONObject: value, options: options)
        self = try decoder.decode(Self.self, from: data)
    }

    init(from value: Any,
         options: JSONSerialization.WritingOptions = [],
         decoderSetupClosure: ((JSONDecoder) -> Void)? = nil) throws {
        let decoder = JSONDecoder()
        decoderSetupClosure?(decoder)
        try self.init(from: value, options: options, decoder: decoder)
    }

    init?(discardingAnErrorFrom value: Any,
          printError: Bool = false,
          options: JSONSerialization.WritingOptions = [],
          decoderSetupClosure: ((JSONDecoder) -> Void)? = nil) {
        do {
            try self.init(from: value, options: options, decoderSetupClosure: decoderSetupClosure)
        } catch {
            if printError { print("\(Self.self) decoding ERROR:\n\(error)") }
            return nil
        }
    }
}
