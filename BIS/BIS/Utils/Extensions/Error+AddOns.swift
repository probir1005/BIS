//
//  Error+AddOns.swift
//  BIS
//
//  Created by TSSIOS on 08/07/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation

 extension Error {
    var codeFromError: Int { return (self as NSError).code }
}
