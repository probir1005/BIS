//
//  BISSignInBuilder.swift
//  BIS
//
//  Created by TSSIOS on 30/07/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

class BISSignInBuilder {

    class func buildModule(arroundView view: SignInVCProtocol) {

        // MARK: - Initialise components.
        let presenter = BISSignInPresenter()
        let interactor = BISSignInInteractor(withApiWorker: BISSignInAPIWorker())

        // MARK: - Link VIP components.
        view.presenter = presenter
        view.interactor = interactor
        presenter.view = view
        interactor.presenter = presenter
    }

}
