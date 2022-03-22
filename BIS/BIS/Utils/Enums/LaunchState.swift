//
//  LaunchState.swift
//  BIS
//
//  Created by TSSIOS on 17/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation

private var isFirstShown = false
private var isAutorized = false

enum LaunchState {

    case splash
    case main(isFirstShown: Bool)
    case auth
//    case onboarding

    // MARK: - Public methods

    static func configure( appInitialShown: Bool = isFirstShown, isAutorized: Bool = isAutorized) -> LaunchState {

        switch isAutorized {
        case false: return .auth
        case true: return .main(isFirstShown: appInitialShown)
        }
    }
}
