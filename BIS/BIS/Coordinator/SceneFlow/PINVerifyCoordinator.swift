//
//  PINVerifyCoordinator.swift
//  BIS
//
//  Created by TSSIOS on 13/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation

final class PINVerifyCoordinator: BaseCoordinator, CoordinatorFinishOutput {

    // MARK: - CoordinatorFinishOutput

    var finishFlow: (() -> Void)?
    var onForgotFlow: (() -> Void)?
    // MARK: - Vars & Lets

    private let router: NavigaterProtocol
    private let viewControllerFactory: ViewControllerFactory

    // MARK: - Private methods

    private func showPINVerifyViewController() {
        let pinVerifyVC = self.viewControllerFactory.instantiatePINVerifyViewController()
        pinVerifyVC.onFinish = { [unowned self] in
            self.finishFlow?()
        }
        pinVerifyVC.onForgotPIN = { [unowned self] in
            self.onForgotFlow?()
        }
        pinVerifyVC.onMaxAttempt = { [unowned self] in
            self.onForgotFlow?()
        }

        self.router.present(pinVerifyVC, animated: true, modalStyle: .overCurrentContext)
    }

    // MARK: - Coordinator

    override func start() {
        self.showPINVerifyViewController()
    }

    // MARK: - Init

    init(router: NavigaterProtocol, viewControllerFactory: ViewControllerFactory) {
        self.router = router
        self.viewControllerFactory = viewControllerFactory
    }

}
