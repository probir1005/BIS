//
//  DefaultError.swift
//  BIS
//
//  Created by TSSIOS on 27/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation

enum DefaultError: Error {
    case status(code: Int)
    case unableToRefreshToken
    case weakIsNil
}

extension Result where Failure == Error {

    static var weakIsNil: Result<Success, Failure> {
        return .failure(DefaultError.weakIsNil)
    }

}
