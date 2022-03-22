//
//  ApplicationCoordinator.swift
//  BIS
//
//  Created by TSSIOS on 14/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation

final class ApplicationCoordinator: BaseCoordinator {

    // MARK: - Vars & Lets

    private var appKeyChain = KeyChainService()
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let router: NavigaterProtocol
    private var launchState = LaunchState.splash
    private let viewControllerFactory: ViewControllerFactory = ViewControllerFactory()

    // MARK: - Coordinator

    override func start(with option: DeepLinkOption?) {
        if option != nil {

        } else {
            switch launchState {
            case .splash: showSplashVC()
            case .auth: runAuthFlow()
            case .main(let isFirstShown): runMainFlow(isFirstShown: isFirstShown)//runMainFlow()
//            case .onboarding: runAFlow()//runOnBoardingFlow()
            }
        }
    }

    // MARK: - Private methods

    private func showSplashVC() {
        let splashVC = self.viewControllerFactory.instantiateSplashVC()
        splashVC.animationComplete = { [unowned self] in
            //self.runAuthFlow()
            if UserDefaultsService().getOTP()?.userName == nil {
                self.launchState = LaunchState.configure(isAutorized: false)
                self.start()
            } else {
                let dbWorker = BISVerifyOTPDBWorker(manager: DependencyInjector.get()!)
                dbWorker.fetchUser(callBack: { user in
                    if user != nil && self.appKeyChain.get(.appLockPIN) != nil && !user!.accessToken.isEmpty {
                        self.launchState = LaunchState.configure(isAutorized: true)
                        self.start()

                    } else {
                        self.launchState = LaunchState.configure(isAutorized: false)
                        self.start()

                    }
                })
            }


//            if let user = UserDefaultsService().getUser(), self.appKeyChain.get(.appLockPIN) != nil, !user.accessToken.isEmpty {
//                self.launchState = LaunchState.configure(isAutorized: true)
//            } else {
//                self.launchState = LaunchState.configure(isAutorized: false)
//            }
        }
        self.router.setRootModule(splashVC, hideNavBar: true)
    }

    private func runAuthFlow() {
        let coordinator = self.coordinatorFactory.makeAuthCoordinatorBox(router: self.router, coordinatorFactory: self.coordinatorFactory, viewControllerFactory: self.viewControllerFactory)
        coordinator.finishFlow = { [unowned self, unowned coordinator] in
            self.removeDependency(coordinator)
            UserDefaults.setVal(value: true, forKey: UserDefaultsKey.notification)
            UserDefaults.setVal(value: true, forKey: UserDefaultsKey.enablePIN)
            UserDefaults.setVal(value: true, forKey: UserDefaultsKey.enableAssistiveZoom)
            self.launchState = LaunchState.configure(appInitialShown: true, isAutorized: true)
            self.start()
        }
        self.addDependency(coordinator)
        coordinator.start()
    }

    private func runMainFlow(isFirstShown: Bool) {
        let coordinator = self.coordinatorFactory.makeDashboardCoordinatorBox(router: self.router, coordinatorFactory: CoordinatorFactory(), viewControllerFactory: ViewControllerFactory())

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
            self.runPINVerificationFlow(isFirstShown: isFirstShown)
        }

        coordinator.finishFlow = { [unowned self, unowned coordinator] in
            UserDefaults.reset()
            self.appKeyChain.clear()
            CoreDataManager().deleteAllData(entity: "User")
            self.removeDependency(coordinator)
            self.launchState = LaunchState.configure(isAutorized: false)
            self.start()
        }
        self.addDependency(coordinator)
        coordinator.start()
    }

    func runPINVerificationFlow(isFirstShown: Bool) {
        if appKeyChain.get(.appLockPIN) != nil && UserDefaults.getVal(forKey: .enablePIN) == true && !isFirstShown {

            let pinCoordinator = self.coordinatorFactory.makePINVerifyBox(router: self.router, viewControllerFactory: ViewControllerFactory())
            pinCoordinator.finishFlow = { [unowned self] in
                self.removeDependency(pinCoordinator)
                self.router.dismissModule(animated: true, completion: nil)
            }
            pinCoordinator.onForgotFlow = { [unowned self] in
                self.removeDependency(pinCoordinator)
                self.router.dismissModule(animated: false, completion: {
                    UserDefaults.reset()
                    self.appKeyChain.clear()
                    self.launchState = LaunchState.configure(isAutorized: false)
                    self.start()
                })

            }

            self.addDependency(pinCoordinator)
            pinCoordinator.start()
        }
    }

    // MARK: - Init

    init(router: Navigater, coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
    }

}
