//
//  AboutUsCoordinator.swift
//  BIS
//
//  Created by TSSIOS on 24/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation

final class AboutUsCoordinator: BaseCoordinator, CoordinatorFinishOutput {

    // MARK: - CoordinatorFinishOutput

    var finishFlow: (() -> Void)?

    // MARK: - Vars & Lets

    private let router: NavigaterProtocol
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let viewControllerFactory: ViewControllerFactory

    // MARK: - Private methods

    private func showAboutUsViewController() {
        let aboutUsVC = self.viewControllerFactory.instantiateAboutUSViewController()
        aboutUsVC.onBack = { [unowned self] in
            self.finishFlow?()
        }
        aboutUsVC.onTandC = { title in
            self.showTandCViewController(title: title, module: aboutUsVC)
        }

        self.router.push(aboutUsVC, hideNavBar: false)
    }

    // MARK: - Coordinator

    private func showTandCViewController(title: String, module: BISAboutUsVC) {
           let privacyVC = self.viewControllerFactory.instantiatePrivacyViewController(title: title)
           privacyVC.onBack = { [unowned self] in
               self.router.popToModule(hideNavBar: false, module: module, animated: true)
           }

           self.router.push(privacyVC, hideNavBar: false)
    }

    override func start() {
        self.showAboutUsViewController()
    }

    // MARK: - Init

    init(router: NavigaterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
        self.viewControllerFactory = viewControllerFactory
    }

}
