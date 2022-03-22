//
//  HelpCoordinator.swift
//  BIS
//
//  Created by TSSIOS on 17/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation

final class HelpCoordinator: BaseCoordinator, CoordinatorFinishOutput {

    // MARK: - CoordinatorFinishOutput

    var finishFlow: (() -> Void)?

    // MARK: - Vars & Lets

    private let router: NavigaterProtocol
    private let viewControllerFactory: ViewControllerFactory

    // MARK: - Private methods

    private func showHelpViewController() {
        let helpVC = self.viewControllerFactory.instantiateHelpViewController()
        helpVC.onBack = { [unowned self] in
                   self.finishFlow?()
        }
        helpVC.onFinish = { [unowned self] in
            self.finishFlow?()
        }
        
        self.router.push(helpVC, hideNavBar: false)
    }

    // MARK: - Coordinator

    override func start() {
        self.showHelpViewController()
    }

    // MARK: - Init

    init(router: NavigaterProtocol, viewControllerFactory: ViewControllerFactory) {
        self.router = router
        self.viewControllerFactory = viewControllerFactory
    }

}
