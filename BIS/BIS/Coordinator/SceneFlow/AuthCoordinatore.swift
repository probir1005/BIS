//
//  AuthCoordinatore.swift
//  BIS
//
//  Created by TSSIOS on 17/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

protocol CoordinatorFinishOutput {
    var finishFlow: (() -> Void)? { get set }
}

final class AuthCoordinator: BaseCoordinator, CoordinatorFinishOutput {

    // MARK: - CoordinatorFinishOutput

       var finishFlow: (() -> Void)?

       // MARK: - Vars & Lets

       private let router: NavigaterProtocol
       private let coordinatorFactory: CoordinatorFactoryProtocol
       private let viewControllerFactory: ViewControllerFactory

       // MARK: - Private methods
    private func showLoginViewController() {
        let loginVC = self.viewControllerFactory.instantiateLoginViewController()
        loginVC.onSignIn = { [unowned self, unowned loginVC] in
            self.showVerifyOTPViewController(module: loginVC)
        }
        loginVC.onPrivacyPolicy = { [unowned self] in
            self.showPrivacyViewController(title: "Privacy Policy")
        }
        loginVC.onTAndC = { [unowned self] in
            self.showPrivacyViewController(title: "Terms & Conditions")
        }

        loginVC.onHelp = { [unowned self, unowned loginVC] in
            self.showHelpViewController(module: loginVC)
        }
        self.router.setRootModule(loginVC, hideNavBar: true)
    }

    private func showVerifyOTPViewController(module: BISSignInVC) {
        let coordinator = self.coordinatorFactory.makeVerifyOTPCoordinatorBox(router: self.router, coordinatorFactory: self.coordinatorFactory, viewControllerFactory: self.viewControllerFactory)
        coordinator.finishFlow = { [unowned self, weak module, unowned coordinator] in
            self.removeDependency(coordinator)
            self.router.popToModule(hideNavBar: true, module: module, animated: false)
            self.showPinRegisterViewController(module: module!)
        }
        self.addDependency(coordinator)
        coordinator.start()

//        let verifyOTPVC = self.viewControllerFactory.instantiateVerifyOTPViewController()
//        verifyOTPVC.onVerify = { [unowned self] in
//            self.showPinRegisterViewController(module: module)
//        }

//        self.router.push(verifyOTPVC, hideNavBar: false)
    }

    private func showPrivacyViewController(title: String) {
        let privacyVC = self.viewControllerFactory.instantiatePrivacyViewController(title: title)
        privacyVC.onBack = { [unowned self] in
            self.router.popToRootModule(hideNavBar: false, animated: true)
        }

        self.router.push(privacyVC, hideNavBar: false)
    }

    private func showHelpViewController(module: BISSignInVC) {
        let coordinator = self.coordinatorFactory.makeHelpCoordinatorBox(router: self.router, viewControllerFactory: self.viewControllerFactory)
        coordinator.finishFlow = { [unowned self, weak module, unowned coordinator] in
            self.removeDependency(coordinator)
            self.router.popToModule(hideNavBar: true, module: module, animated: true)
        }
        self.addDependency(coordinator)
        coordinator.start()
    }

    private func showPinRegisterViewController(module: BISSignInVC) {
        let coordinator = self.coordinatorFactory.makePINRegisterCoordinatorBox(router: self.router, viewControllerFactory: self.viewControllerFactory)
        coordinator.finishFlow = { [unowned self] in
            self.finishFlow?()
//            self.removeDependency(coordinator)
//            self.router.popToModule(hideNavBar: true, module: module, animated: true)
        }
        self.addDependency(coordinator)
        coordinator.start()
    }

    // MARK: - Coordinator

    override func start() {
        self.showLoginViewController()
    }

    // MARK: - Init

    init(router: NavigaterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
        self.viewControllerFactory = viewControllerFactory
    }

}
