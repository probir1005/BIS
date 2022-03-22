//
//  TabBarCoordinator.swift
//  BIS
//
//  Created by TSSIOS on 23/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation

final class TabBarCoordinator: BaseCoordinator, CoordinatorFinishOutput {

    // MARK: - CoordinatorFinishOutput

    var finishFlow: (() -> Void)?

    // MARK: - Vars & Lets

    private let router: NavigaterProtocol
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let viewControllerFactory: ViewControllerFactory

    // MARK: - Private methods

    private func addTabBarController() -> BISTabBarVC {
        let controllers = [self.createHomeViewController(), self.createFavouritesViewController(), self.createAlertsViewController(), self.createSettingsViewController()]
        let tabBarVC = self.viewControllerFactory.instantiateTabBarController(controllers: controllers)
        tabBarVC.onHome = { [unowned self] in
            self.finishFlow?()
        }
        tabBarVC.onFavourites = { [unowned self] in
            self.finishFlow?()
        }
        tabBarVC.onAlerts = { [unowned self] in
            self.finishFlow?()
        }
        tabBarVC.onSettings = { [unowned self] in
            self.finishFlow?()
        }
        tabBarVC.onFinish = { [unowned self] in
            self.finishFlow?()
        }
        return tabBarVC
    }

    // MARK: - Coordinator

    private func createSettingsViewController() -> CustomNavigationController {
        let navController = CustomNavigationController()
        let settingsRouter = Navigater(rootController: navController)

        let coordinator = self.coordinatorFactory.makeSettingsCoordinatorBox(router: settingsRouter, coordinatorFactory: coordinatorFactory, viewControllerFactory: self.viewControllerFactory)
        coordinator.finishFlow = { [unowned self, unowned coordinator] in
            self.removeDependency(coordinator)
//            self.router.popToModule(hideNavBar: true, module: module, animated: true)
        }
        self.addDependency(coordinator)
        coordinator.start()
        return navController
    }

    private func createHomeViewController() -> CustomNavigationController {
            let navController = CustomNavigationController()
            let homeRouter = Navigater(rootController: navController)

            let coordinator = self.coordinatorFactory.makeHomeCoordinatorBox(router: homeRouter, coordinatorFactory: coordinatorFactory, viewControllerFactory: self.viewControllerFactory)
            coordinator.finishFlow = { [unowned self, unowned coordinator] in
                self.removeDependency(coordinator)
    //            self.router.popToModule(hideNavBar: true, module: module, animated: true)
            }
            self.addDependency(coordinator)
            coordinator.start()
            return navController
    }

    private func createFavouritesViewController() -> CustomNavigationController {
            let navController = CustomNavigationController()
            let favouritesRouter = Navigater(rootController: navController)

            let coordinator = self.coordinatorFactory.makeFavouritesCoordinatorBox(router: favouritesRouter, coordinatorFactory: coordinatorFactory, viewControllerFactory: self.viewControllerFactory)
            coordinator.finishFlow = { [unowned self, unowned coordinator] in
                self.removeDependency(coordinator)
    //            self.router.popToModule(hideNavBar: true, module: module, animated: true)
            }
            self.addDependency(coordinator)
            coordinator.start()
            return navController
    }

    private func createAlertsViewController() -> CustomNavigationController {
            let navController = CustomNavigationController()
            let alertsRouter = Navigater(rootController: navController)

            let coordinator = self.coordinatorFactory.makeNotificationAlertsCoordinatorBox(router: alertsRouter, coordinatorFactory: coordinatorFactory, viewControllerFactory: self.viewControllerFactory)
            coordinator.finishFlow = { [unowned self, unowned coordinator] in
                self.removeDependency(coordinator)
    //            self.router.popToModule(hideNavBar: true, module: module, animated: true)
            }
            self.addDependency(coordinator)
            coordinator.start()
            return navController
    }

    func start() -> BISTabBarVC {
        return self.addTabBarController()
    }

    // MARK: - Init

    init(router: NavigaterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
        self.viewControllerFactory = viewControllerFactory
    }

}
