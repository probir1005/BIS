//
//  BISPINVerifyBuilder.swift
//  BIS
//
//  Created by TSSIOS on 14/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

class BISPINVerifyBuilder {

    class func buildModule(arroundView view: PINVerifyVCProtocol) {

        // MARK: - Initialise components.
        let presenter = BISPINVerifyPresenter()
        let interactor = BISPINVerifyInteractor()

        // MARK: - Link VIP components.
        view.presenter = presenter
        view.interactor = interactor
        presenter.view = view
        interactor.presenter = presenter
    }

}
