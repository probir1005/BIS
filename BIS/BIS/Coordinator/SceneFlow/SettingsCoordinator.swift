//
//  SettingsCoordinator.swift
//  BIS
//
//  Created by TSSIOS on 24/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation

final class SettingsCoordinator: BaseCoordinator, CoordinatorFinishOutput {

    // MARK: - CoordinatorFinishOutput

    var finishFlow: (() -> Void)?

    // MARK: - Vars & Lets

    private let router: NavigaterProtocol
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let viewControllerFactory: ViewControllerFactory

    // MARK: - Private methods

    private func createSettingsViewController() {
        let settingsVC = self.viewControllerFactory.instantiateSettingsViewController()
        settingsVC.onChangePIN = { [unowned self, unowned settingsVC] in
            self.showChangePINViewController(module: settingsVC)
        }
        settingsVC.onPrivacyPolicy = { title in
            self.showPrivacyViewController(title: title)
        }
        settingsVC.onAboutUS = { [unowned self] in
            self.showAboutUsViewController(module: settingsVC)
        }
        settingsVC.onFinish = { [unowned self] in
            self.finishFlow?()
        }
        self.router.setRootModule(settingsVC, hideNavBar: true)
    }

    private func showAboutUsViewController(module: BISSettingsVC) {
        let coordinator = self.coordinatorFactory.makeAboutUsCoordinatorBox(router: self.router, coordinatorFactory: coordinatorFactory, viewControllerFactory: self.viewControllerFactory)
        coordinator.finishFlow = { [unowned self, weak module, unowned coordinator] in
            self.removeDependency(coordinator)
            self.router.popToModule(hideNavBar: false, module: module, animated: true)
        }
        self.addDependency(coordinator)
        coordinator.start()
    }

    private func showPrivacyViewController(title: String) {
        let privacyVC = self.viewControllerFactory.instantiatePrivacyViewController(title: title)
        privacyVC.onBack = { [unowned self] in
            self.router.popToRootModule(hideNavBar: false, animated: true)
        }

        self.router.push(privacyVC, hideNavBar: false)
    }

    private func showChangePINViewController(module: BISSettingsVC) {
        let coordinator = self.coordinatorFactory.makeChangePINCoordinatorBox(router: self.router, coordinatorFactory: coordinatorFactory, viewControllerFactory: self.viewControllerFactory)
        coordinator.finishFlow = { [unowned self, weak module, unowned coordinator] in
            self.removeDependency(coordinator)
            self.router.popToModule(hideNavBar: false, module: module, animated: true)
        }
        self.addDependency(coordinator)
        coordinator.start()
    }

    // MARK: - Coordinator

     override func start() {
        self.createSettingsViewController()
    }

    // MARK: - Init

    init(router: NavigaterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
        self.viewControllerFactory = viewControllerFactory
    }

}
