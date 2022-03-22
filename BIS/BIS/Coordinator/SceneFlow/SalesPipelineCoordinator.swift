//
//  SalesPipelineCoordinator.swift
//  BIS
//
//  Created by TSSIOS on 14/07/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

final class SalesPipelineCoordinator: BaseCoordinator, CoordinatorFinishOutput {

    // MARK: - CoordinatorFinishOutput

    var finishFlow: (() -> Void)?

    // MARK: - Vars & Lets

    private let router: NavigaterProtocol
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let viewControllerFactory: ViewControllerFactory

    // MARK: - Private methods

    private func createSalesPipelineViewController() -> BISOperationsHomeVC {
        let salesPipelineVC = self.viewControllerFactory.instantiateSalesPipelineViewController()
        salesPipelineVC.onDetail = { data in
            self.showDetailScreen(data: data)
        }

        return salesPipelineVC
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

    func start() -> BISOperationsHomeVC {
        return self.createSalesPipelineViewController()
    }

    // MARK: - Init

    init(router: NavigaterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
        self.viewControllerFactory = viewControllerFactory
    }

}
