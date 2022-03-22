//
//  CoordinatorFactory.swift
//  BIS
//
//  Created by TSSIOS on 14/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

protocol CoordinatorFactoryProtocol {
    func makeAuthCoordinatorBox(router: NavigaterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) -> AuthCoordinator
    func makeHelpCoordinatorBox(router: NavigaterProtocol, viewControllerFactory: ViewControllerFactory) -> HelpCoordinator
    func makeVerifyOTPCoordinatorBox(router: NavigaterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) -> VerifyOTPCoordinator
    func makePINRegisterCoordinatorBox(router: NavigaterProtocol, viewControllerFactory: ViewControllerFactory) -> PINRegisterCoordinator
    func makeDashboardCoordinatorBox(router: NavigaterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) -> DashboardCoordinator
    func makeBiometricCoordinatorBox(router: NavigaterProtocol, viewControllerFactory: ViewControllerFactory) -> BiometricCoordinator
    func makePINVerifyBox(router: NavigaterProtocol, viewControllerFactory: ViewControllerFactory) -> PINVerifyCoordinator
    func makeTabBarCoordinatorBox(router: NavigaterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) -> TabBarCoordinator
    func makeHomeCoordinatorBox(router: NavigaterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) -> HomeCoordinator
    func makeFavouritesCoordinatorBox(router: NavigaterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) -> FavouritesCoordinator
    func makeNotificationAlertsCoordinatorBox(router: NavigaterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) -> NotificationAlertCoordinator
    func makeSettingsCoordinatorBox(router: NavigaterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) -> SettingsCoordinator
    func makeChangePINCoordinatorBox(router: NavigaterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) -> ChangePINCoordinator
    func makeAboutUsCoordinatorBox(router: NavigaterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) -> AboutUsCoordinator
    func makeChartDetailCoordinatorBox(router: NavigaterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) -> ChartDetailCoordinator
    func makeSalesPICCoordinatorBox(router: NavigaterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) -> SalesPICCoordinator
    func makeSalesPipelineCoordinatorBox(router: NavigaterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) -> SalesPipelineCoordinator
    func makeManagementCoordinatorBox(router: NavigaterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) -> ManagementCoordinator
}

final class CoordinatorFactory: CoordinatorFactoryProtocol {    

    // MARK: - CoordinatorFactoryProtocol

    func makeAuthCoordinatorBox(router: NavigaterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) -> AuthCoordinator {
        let coordinator = AuthCoordinator(router: router, coordinatorFactory: coordinatorFactory, viewControllerFactory: viewControllerFactory)
        return coordinator
    }

    func makeHelpCoordinatorBox(router: NavigaterProtocol, viewControllerFactory: ViewControllerFactory) -> HelpCoordinator {
        let coordinator = HelpCoordinator(router: router, viewControllerFactory: viewControllerFactory)
        return coordinator
    }

    func makeVerifyOTPCoordinatorBox(router: NavigaterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) -> VerifyOTPCoordinator {
        let coordinator = VerifyOTPCoordinator(router: router, coordinatorFactory: coordinatorFactory, viewControllerFactory: viewControllerFactory)
        return coordinator
    }

    func makePINRegisterCoordinatorBox(router: NavigaterProtocol, viewControllerFactory: ViewControllerFactory) -> PINRegisterCoordinator {
        let coordinator = PINRegisterCoordinator(router: router, viewControllerFactory: viewControllerFactory)
        return coordinator
    }

    func makePINVerifyBox(router: NavigaterProtocol, viewControllerFactory: ViewControllerFactory) -> PINVerifyCoordinator {
        let coordinator = PINVerifyCoordinator(router: router, viewControllerFactory: viewControllerFactory)
        return coordinator
    }

    func makeDashboardCoordinatorBox(router: NavigaterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) -> DashboardCoordinator {
        let coordinator = DashboardCoordinator(router: router, coordinatorFactory: coordinatorFactory, viewControllerFactory: viewControllerFactory)
        return coordinator
    }

    func makeBiometricCoordinatorBox(router: NavigaterProtocol, viewControllerFactory: ViewControllerFactory) -> BiometricCoordinator {
        let coordinator = BiometricCoordinator(router: router, viewControllerFactory: viewControllerFactory)
        return coordinator
    }

    func makeTabBarCoordinatorBox(router: NavigaterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) -> TabBarCoordinator {
        let coordinator = TabBarCoordinator(router: router, coordinatorFactory: coordinatorFactory, viewControllerFactory: viewControllerFactory)
        return coordinator
    }

    func makeHomeCoordinatorBox(router: NavigaterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) -> HomeCoordinator {
        let coordinator = HomeCoordinator(router: router, coordinatorFactory: coordinatorFactory, viewControllerFactory: viewControllerFactory)
        return coordinator
    }

    func makeFavouritesCoordinatorBox(router: NavigaterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) -> FavouritesCoordinator {
        let coordinator = FavouritesCoordinator(router: router, coordinatorFactory: coordinatorFactory, viewControllerFactory: viewControllerFactory)
        return coordinator
    }

    func makeNotificationAlertsCoordinatorBox(router: NavigaterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) -> NotificationAlertCoordinator {
        let coordinator = NotificationAlertCoordinator(router: router, coordinatorFactory: coordinatorFactory, viewControllerFactory: viewControllerFactory)
        return coordinator
    }

    func makeSettingsCoordinatorBox(router: NavigaterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) -> SettingsCoordinator {
        let coordinator = SettingsCoordinator(router: router, coordinatorFactory: coordinatorFactory, viewControllerFactory: viewControllerFactory)
        return coordinator
    }

    func makeChangePINCoordinatorBox(router: NavigaterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) -> ChangePINCoordinator {
        let coordinator = ChangePINCoordinator(router: router, coordinatorFactory: coordinatorFactory, viewControllerFactory: viewControllerFactory)
        return coordinator
    }

    func makeAboutUsCoordinatorBox(router: NavigaterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) -> AboutUsCoordinator {
        let coordinator = AboutUsCoordinator(router: router, coordinatorFactory: coordinatorFactory, viewControllerFactory: viewControllerFactory)
        return coordinator
    }

    func makeChartDetailCoordinatorBox(router: NavigaterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) -> ChartDetailCoordinator {
        let coordinator = ChartDetailCoordinator(router: router, coordinatorFactory: coordinatorFactory, viewControllerFactory: viewControllerFactory)
        return coordinator
    }

    func makeSalesPICCoordinatorBox(router: NavigaterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) -> SalesPICCoordinator {
        let coordinator = SalesPICCoordinator(router: router, coordinatorFactory: coordinatorFactory, viewControllerFactory: viewControllerFactory)
        return coordinator
    }

    func makeSalesPipelineCoordinatorBox(router: NavigaterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) -> SalesPipelineCoordinator {
        let coordinator = SalesPipelineCoordinator(router: router, coordinatorFactory: coordinatorFactory, viewControllerFactory: viewControllerFactory)
        return coordinator
    }

    func makeManagementCoordinatorBox(router: NavigaterProtocol, coordinatorFactory: CoordinatorFactoryProtocol, viewControllerFactory: ViewControllerFactory) -> ManagementCoordinator {
        let coordinator = ManagementCoordinator(router: router, coordinatorFactory: coordinatorFactory, viewControllerFactory: viewControllerFactory)
        return coordinator
    }
}
