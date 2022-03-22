//
//  HomeCoordinator.swift
//  BIS
//
//  Created by TSSIOS on 25/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation

final class HomeCoordinator: BaseCoordinator, CoordinatorFinishOutput {

    // MARK: - CoordinatorFinishOutput

    var finishFlow: (() -> Void)?

    // MARK: - Vars & Lets

    private let router: NavigaterProtocol
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let viewControllerFactory: ViewControllerFactory

    // MARK: - Private methods
    private func createHomeViewController() {
        let controllers = [self.createManagementViewController(), self.createSalesPICViewController(), self.createSalesPipelineViewController()]

        let homeVC = self.viewControllerFactory.instantiateHomeViewController(controllers: controllers)

        homeVC.onFinish = { [unowned self] in
            self.finishFlow?()
        }
        homeVC.onFilter = {
            self.filerScreen()
        }
        self.router.setRootModule(homeVC, hideNavBar: true)
    }

    func filerScreen() {
        let filterVC = self.viewControllerFactory.instantiateFilterViewController()
        filterVC.onBack = { [unowned self] in
            self.router.dismissModule(animated: true, completion: nil)
        }
        filterVC.onFinish = { [unowned self] in
            self.router.dismissModule(animated: true, completion: nil)
        }
        self.router.present(filterVC, animated: true)
    }

    private func createSalesPICViewController() -> BISDashboardBaseVC {

        let coordinator = self.coordinatorFactory.makeSalesPICCoordinatorBox(router: self.router, coordinatorFactory: coordinatorFactory, viewControllerFactory: self.viewControllerFactory)
        coordinator.finishFlow = { [unowned self, unowned coordinator] in
            self.removeDependency(coordinator)
        }
        self.addDependency(coordinator)
        return coordinator.start()
    }

    private func createSalesPipelineViewController() -> BISDashboardBaseVC {
        
        let coordinator = self.coordinatorFactory.makeSalesPipelineCoordinatorBox(router: self.router, coordinatorFactory: coordinatorFactory, viewControllerFactory: self.viewControllerFactory)
        coordinator.finishFlow = { [unowned self, unowned coordinator] in
            self.removeDependency(coordinator)
        }
        self.addDependency(coordinator)
        return coordinator.start()
    }

    private func createManagementViewController() -> BISDashboardBaseVC {

        let coordinator = self.coordinatorFactory.makeManagementCoordinatorBox(router: self.router, coordinatorFactory: coordinatorFactory, viewControllerFactory: self.viewControllerFactory)
        coordinator.finishFlow = { [unowned self, unowned coordinator] in
            self.removeDependency(coordinator)
        }
        self.addDependency(coordinator)
        return coordinator.start()
    }

    // MARK: - Coordinator

    override func start() {
        self.createHomeViewController()
    }

    // MARK: - Init

    init(router: NavigaterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
        self.viewControllerFactory = viewControllerFactory
    }

}
