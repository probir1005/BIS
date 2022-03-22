//
//  PINRegisterCoordinator.swift
//  BIS
//
//  Created by TSSIOS on 20/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation

final class PINRegisterCoordinator: BaseCoordinator, CoordinatorFinishOutput {

    // MARK: - CoordinatorFinishOutput

    var finishFlow: (() -> Void)?

    // MARK: - Vars & Lets

    private let router: NavigaterProtocol
    private let viewControllerFactory: ViewControllerFactory

    // MARK: - Private methods

    private func showPinRegisterViewController(pin: String?) {
        let pinRegisterVC = self.viewControllerFactory.instantiatePINRegisterViewController(pin: pin)
        pinRegisterVC.onNextStep = { pin in
            self.showPINConfirmViewController(pin: pin)
        }
        
//        pinRegisterVC.onNextStep = { [unowned self] in
//            self.showPINConfirmViewController()
//        }
//        pinRegisterVC.onError = { [unowned self] in
//            self.router.popModule(hideNavBar: true)
//        }
//        pinRegisterVC.onFinish = { [unowned self] in
//            self.finishFlow?()
//        }

        self.router.push(pinRegisterVC, hideNavBar: true)
    }

    private func showPINConfirmViewController(pin: String) {

        let pinConfirmVC = self.viewControllerFactory.instantiatePINRegisterViewController(pin: pin)

        pinConfirmVC.onError = { [unowned self] in
            self.router.popToRootModule(hideNavBar: true, animated: false)
            self.showPinRegisterViewController(pin: "")
//            self.router.popModule(hideNavBar: true)
        }
        pinConfirmVC.onFinish = { [unowned self] in
            self.showBiometricEnableViewController()
        }

        self.router.push(pinConfirmVC, hideNavBar: true)
    }

    private func showBiometricEnableViewController() {
        //TODO: Coordinator created but not used
        let biometricEnableVC = self.viewControllerFactory.instantiateBiometricsViewController()
        biometricEnableVC.onSkip = { [unowned self] in
            self.finishFlow?()
        }
        biometricEnableVC.onFinish = { [unowned self] in
            self.finishFlow?()
        }

        self.router.push(biometricEnableVC, hideNavBar: true)
    }

    // MARK: - Coordinator

    override func start() {
        self.showPinRegisterViewController(pin: nil)
    }

    // MARK: - Init

    init(router: NavigaterProtocol, viewControllerFactory: ViewControllerFactory) {
        self.router = router
        self.viewControllerFactory = viewControllerFactory
    }

}
