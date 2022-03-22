//
//  FavouritesCoordinator.swift
//  BIS
//
//  Created by TSSIOS on 25/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation

final class FavouritesCoordinator: BaseCoordinator, CoordinatorFinishOutput {

    // MARK: - CoordinatorFinishOutput

    var finishFlow: (() -> Void)?

    // MARK: - Vars & Lets

    private let router: NavigaterProtocol
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let viewControllerFactory: ViewControllerFactory

    // MARK: - Private methods
    private func createAlertViewController() {
           let favouritesVC = self.viewControllerFactory.instantiateFavouritesViewController()

           favouritesVC.onFinish = { [unowned self] in
               self.finishFlow?()
           }
           self.router.setRootModule(favouritesVC, hideNavBar: true)
       }

    // MARK: - Coordinator

     override func start() {
        self.createAlertViewController()
    }

    // MARK: - Init

    init(router: NavigaterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
        self.viewControllerFactory = viewControllerFactory
    }

}
