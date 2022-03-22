//
//  BISPINRRegisterBuilder.swift
//  BIS
//
//  Created by TSSIOS on 21/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

class BISPINRRegisterBuilder {

    class func buildModule(arroundView view: PINRegisterVCProtocol, pin: String?) {

        // MARK: - Initialise components.
        let presenter = BISPINRegisterPresenter()
        let interactor = BISPINRegisterInteractor(withPIN: pin)

        // MARK: - Link VIP components.
        view.presenter = presenter
        view.interactor = interactor
        presenter.view = view
        interactor.presenter = presenter
    }

}
