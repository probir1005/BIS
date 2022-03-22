//
//  ChangePINCoordinator.swift
//  BIS
//
//  Created by TSSIOS on 23/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation

final class ChangePINCoordinator: BaseCoordinator, CoordinatorFinishOutput {

    // MARK: - CoordinatorFinishOutput

    var finishFlow: (() -> Void)?
    private var appKeyChain = KeyChainService()

    // MARK: - Vars & Lets

    private let router: NavigaterProtocol
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let viewControllerFactory: ViewControllerFactory

    // MARK: - Private methods

    private func showChangePINViewController(pin: String?) {
        guard let savedPIN = appKeyChain.get(.appLockPIN) else {
            return
        }
        let ChangePINVC = self.viewControllerFactory.instantiateChangePINViewController(pin: pin, savedPin: savedPIN)
//        ChangePINVC.onNextStep = { pin in
//            self.showNewPINViewController(pin: "" )
//        }

        ChangePINVC.onNewPIN = { [unowned self] in
            self.showNewPINViewController(pin: nil)
        }

//        ChangePINVC.onNextStep = { [unowned self] in
//            self.showPINConfirmViewController()
//        }
//        ChangePINVC.onError = { [unowned self] in
//            self.router.popModule(hideNavBar: true)
//        }
        ChangePINVC.onFinish = { [unowned self] in
            self.finishFlow?()
        }

//        self.router.push(ChangePINVC, transition: nil, animated: pin == nil, hideNavBar: true)
        self.router.push(ChangePINVC, hideNavBar: true)

    }

    private func showNewPINViewController(pin: String?) {

        let newPINVC = self.viewControllerFactory.instantiateChangePINViewController(pin: pin, savedPin: nil)
        newPINVC.onNextStep = { pin in
            self.showPINConfirmViewController(pin: pin, module: newPINVC)
        }
        newPINVC.onFinish = { [unowned self] in
            self.finishFlow?()
        }

        self.router.push(newPINVC, transition: nil, animated: pin == nil, hideNavBar: true)

//        self.router.push(newPINVC, hideNavBar: true)
    }

    private func showPINConfirmViewController(pin: String, module: BISChangePINVC) {

        let pinConfirmVC = self.viewControllerFactory.instantiateChangePINViewController(pin: pin, savedPin: nil)

        pinConfirmVC.onError = { [unowned self, unowned module] in
            self.router.popToModule(hideNavBar: true, module: module, animated: false)
            self.showNewPINViewController(pin: "")
        }
        pinConfirmVC.onFinish = { [unowned self] in
            self.router.popToRootModule(hideNavBar: false, animated: false)
        }

        self.router.push(pinConfirmVC, hideNavBar: true)
    }

    // MARK: - Coordinator

    override func start() {
        self.showChangePINViewController(pin: nil)
    }

    // MARK: - Init

    init(router: NavigaterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
        self.viewControllerFactory = viewControllerFactory
    }

}
