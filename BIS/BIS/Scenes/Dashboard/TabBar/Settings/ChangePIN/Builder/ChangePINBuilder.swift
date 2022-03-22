//
//  ChangePINBuilder.swift
//  BIS
//
//  Created by TSSIOS on 23/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

class BISChangePINBuilder {

    class func buildModule(arroundView view: ChangePINVCProtocol, pin: String?, savedPin: String?) {

        // MARK: - Initialise components.
        let presenter = BISChangePINPresenter()
        let interactor = BISChangePINInteractor(withPIN: pin, and: savedPin)

        // MARK: - Link VIP components.
        view.presenter = presenter
        view.interactor = interactor
        presenter.view = view
        interactor.presenter = presenter
    }

}
