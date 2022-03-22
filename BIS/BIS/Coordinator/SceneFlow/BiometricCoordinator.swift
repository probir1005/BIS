//
//  BiometricCoordinator.swift
//  BIS
//
//  Created by TSSIT on 21/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation

final class BiometricCoordinator: BaseCoordinator, CoordinatorFinishOutput {

    // MARK: - CoordinatorFinishOutput
    var finishFlow: (() -> Void)?

    // MARK: - Vars & Lets

    private let router: NavigaterProtocol
    private let viewControllerFactory: ViewControllerFactory

    // MARK: - Private methods

    private func showBiometricViewController() {
        let biometricVC = self.viewControllerFactory.instantiateBiometricsViewController()
        biometricVC.onSkip = { [unowned self] in
                   self.finishFlow?()
        }
        biometricVC.onFinish = { [unowned self] in
            self.finishFlow?()
        }
        
        self.router.push(biometricVC, hideNavBar: true)
    }

    // MARK: - Coordinator

    override func start() {
        self.showBiometricViewController()
    }

    // MARK: - Init

    init(router: NavigaterProtocol, viewControllerFactory: ViewControllerFactory) {
        self.router = router
        self.viewControllerFactory = viewControllerFactory
    }

}
