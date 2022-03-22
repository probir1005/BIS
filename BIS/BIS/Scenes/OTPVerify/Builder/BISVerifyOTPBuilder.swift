//
//  BISVerifyOTPBuilder.swift
//  BIS
//
//  Created by TSSIOS on 27/08/20.
//  Copyright © 2020 TSS. All rights reserved.
//

import UIKit

class BISVerifyOTPBuilder {

    class func buildModule(arroundView view: VerifyOTPVCProtocol) {

        // MARK: - Initialise components.
        let presenter = BISVerifyOTPPresenter()
        let interactor = BISVerifyOTPInteractor(withApiWorker: BISVerifyOTPAPIWorker(), withDBWorker: BISVerifyOTPDBWorker(manager: DependencyInjector.get()!))

        // MARK: - Link VIP components.
        view.presenter = presenter
        view.interactor = interactor
        presenter.view = view
        interactor.presenter = presenter
    }

}
