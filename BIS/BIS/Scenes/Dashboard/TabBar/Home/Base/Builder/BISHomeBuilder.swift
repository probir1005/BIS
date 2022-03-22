//
//  BISHomeBuilder.swift
//  BIS
//
//  Created by TSSIOS on 15/07/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

class BISHomeBuilder {

    class func buildModule(arroundView view: HomeVCProtocol, controllers: [BISDashboardBaseVC]) {

        // MARK: - Initialise components.
        let presenter = BISHomePresenter()
        let interactor = BISHomeInteractor(withControllers: controllers)

        // MARK: - Link VIP components.
        view.presenter = presenter
        view.interactor = interactor
        presenter.view = view
        interactor.presenter = presenter
    }

}
