//
//  ChartDetailCoordinator.swift
//  BIS
//
//  Created by TSSIOS on 14/07/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

final class ChartDetailCoordinator: BaseCoordinator, CoordinatorFinishOutput {

    // MARK: - CoordinatorFinishOutput

    var finishFlow: (() -> Void)?

    // MARK: - Vars & Lets

    private let router: NavigaterProtocol
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let viewControllerFactory: ViewControllerFactory

    // MARK: - Private methods

    private func showDetailViewController(data: HomeChartDTO) {
        let detailVC = self.viewControllerFactory.instantiateChartDetailViewController(data: data)
        detailVC.onBack = { [unowned self] in
            self.router.popModule(hideNavBar: false)
        }
        detailVC.onFinish = { [unowned self] in
            self.finishFlow?()
        }

        self.router.push(detailVC, hideNavBar: false)
    }

    // MARK: - Coordinator

    func start(data: HomeChartDTO) {
        self.showDetailViewController(data: data)
    }

    // MARK: - Init

    init(router: NavigaterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
        self.viewControllerFactory = viewControllerFactory
    }

}
