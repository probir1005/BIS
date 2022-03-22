//
//  DashboardCoordinator.swift
//  BIS
//
//  Created by TSSIOS on 20/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

final class DashboardCoordinator: BaseCoordinator, CoordinatorFinishOutput {

    // MARK: - CoordinatorFinishOutput

    var finishFlow: (() -> Void)?

    // MARK: - Vars & Lets

    private let router: NavigaterProtocol
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let viewControllerFactory: ViewControllerFactory

    // MARK: - Private methods
    
    private func showDashboardViewController() {
        let tabBarVC = self.createTabBarViewController()

        let menuVC = BISMenuVC(nibName: String(describing: BISMenuVC.self), bundle: nil)

        let dashboardVC = self.viewControllerFactory.instantiateDashboardViewController(with: tabBarVC, sidePanel: menuVC)
        dashboardVC.onFinish = { [unowned self] in
            self.finishFlow?()
        }
        dashboardVC.onTabBar = { [unowned self] in
            guard let drawer = self.router.rootNavController?.topMostViewController() as? CustomSidePanel else {
                return
            }

            drawer.replace(center: tabBarVC)
        }

        self.router.setRootModule(dashboardVC, hideNavBar: true)
    }

    // MARK: - Coordinator
    private func createTabBarViewController() -> BISTabBarVC {
        let coordinator = self.coordinatorFactory.makeTabBarCoordinatorBox(router: self.router, coordinatorFactory: coordinatorFactory, viewControllerFactory: self.viewControllerFactory)
        coordinator.finishFlow = { [unowned self, unowned coordinator] in
            self.removeDependency(coordinator)
        }
        self.addDependency(coordinator)
        return coordinator.start()
    }

    override func start() {
        self.showDashboardViewController()
    }

    // MARK: - Init

    init(router: NavigaterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
        self.viewControllerFactory = viewControllerFactory
    }

}
