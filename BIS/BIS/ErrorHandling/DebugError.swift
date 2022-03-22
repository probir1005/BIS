//
//  DebugError.swift
//  BIS
//
//  Created by TSSIOS on 27/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation

struct DebugError: Error, CustomStringConvertible {

    let message: String

    var description: String {
        return "Error: \(message)"
    }

}
