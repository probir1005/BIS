//
//  SalesPICCoordinator.swift
//  BIS
//
//  Created by TSSIOS on 14/07/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

final class SalesPICCoordinator: BaseCoordinator, CoordinatorFinishOutput {

    // MARK: - CoordinatorFinishOutput

    var finishFlow: (() -> Void)?

    // MARK: - Vars & Lets

    private let router: NavigaterProtocol
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let viewControllerFactory: ViewControllerFactory

    // MARK: - Private methods

    private func createSalesPICViewController() -> BISSalesPICHomeVC {
        let salesPICVC = self.viewControllerFactory.instantiateSalesPICViewController()
        salesPICVC.onDetail = { data in
            self.showDetailScreen(data: data)
        }

       return salesPICVC
    }

    // MARK: - Coordinator
    func showDetailScreen(data: HomeChartDTO) {
        let coordinator = self.coordinatorFactory.makeChartDetailCoordinatorBox(router: self.router, coordinatorFactory: self.coordinatorFactory, viewControllerFactory: self.viewControllerFactory)
        coordinator.finishFlow = { [unowned self, unowned coordinator] in
            self.removeDependency(coordinator)
            self.router.popToRootModule(hideNavBar: false, animated: true)
        }
        self.addDependency(coordinator)
        coordinator.start(data: data)
    }

    func start() -> BISSalesPICHomeVC {
        return self.createSalesPICViewController()
    }

    // MARK: - Init

    init(router: NavigaterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
        self.viewControllerFactory = viewControllerFactory
    }

}
