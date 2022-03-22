//
//  VerifyOTPCoordinator.swift
//  BIS
//
//  Created by TSSIOS on 28/08/20.
//  Copyright © 2020 TSS. All rights reserved.
//

import Foundation

final class VerifyOTPCoordinator: BaseCoordinator, CoordinatorFinishOutput {

    // MARK: - CoordinatorFinishOutput
    var finishFlow: (() -> Void)?

    // MARK: - Vars & Lets

    private let router: NavigaterProtocol
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let viewControllerFactory: ViewControllerFactory

    // MARK: - Private methods

    private func showVerifyOTPViewController() {
        let verifyOTPVC = self.viewControllerFactory.instantiateVerifyOTPViewController()
        verifyOTPVC.onVerify = { [unowned self] in
            self.finishFlow?()
        }

        self.router.push(verifyOTPVC, hideNavBar: true)
    }

    private func showPinRegisterViewController() {
            let coordinator = self.coordinatorFactory.makePINRegisterCoordinatorBox(router: self.router, viewControllerFactory: self.viewControllerFactory)
            coordinator.finishFlow = { [unowned self] in
                self.finishFlow?()
                self.removeDependency(coordinator)
    //            self.router.popToModule(hideNavBar: true, module: module, animated: true)
            }
            self.addDependency(coordinator)
            coordinator.start()
        }

    // MARK: - Coordinator

    override func start() {
        self.showVerifyOTPViewController()
    }

    // MARK: - Init

    init(router: NavigaterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
        self.viewControllerFactory = viewControllerFactory
    }

}
