//
//  SceneDelegate.swift
//  BIS
//
//  Created by TSSIOS on 04/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    static let backroundScreenInterval = 10.0
    var window: UIWindow?
    var layerView: CustomLayerView?
    private var appKeyChain = KeyChainService()
//    var rootController: UINavigationController {
//        return self.window!.rootViewController as! UINavigationController
//    }
    var appCoordinator: ApplicationCoordinator!
    var duration: TimeInterval = 0.0

//    private lazy var applicationCoordinator: Coordinator = ApplicationCoordinator(router: Navigater(rootController: self.rootController), coordinatorFactory: CoordinatorFactory())

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        self.duration = 4.0
        // 1
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // 2
        let appWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
        appWindow.windowScene = windowScene

        // 3
        let navController = CustomNavigationController()
        appCoordinator = ApplicationCoordinator(router: Navigater(rootController: navController), coordinatorFactory: CoordinatorFactory())
        appCoordinator.start(with: nil)

        // 4
        appWindow.rootViewController = navController
        appWindow.makeKeyAndVisible()

        // 5
        window = appWindow

        if let interfaceOrientation = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.windowScene?.interfaceOrientation {
            CustomNavigationController.appDelegate.landscape = interfaceOrientation.isLandscape
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        if layerView != nil {
            layerView?.removeLayer()
            layerView = nil
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
        layerView = CustomLayerView(frame: self.window!.frame)
        if !(UIApplication.shared.topMostViewController() is BISPINVerifyVC) && !(UIApplication.shared.topMostViewController() is BISBiometricsVC) {
            UIApplication.shared.sendAction(
                #selector(self.resignFirstResponder), to: nil, from: nil, for: nil)
            layerView?.showLayer()
        }
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        DispatchQueue.main.asyncAfter(deadline: .now() + self.duration) {
            self.duration = 0.1
            if self.appKeyChain.get(.appLockPIN) != nil && UserDefaults.getVal(forKey: .enablePIN) == true && !(UIApplication.shared.topMostViewController() is BISPINVerifyVC) && self.appCoordinator != nil {
                let time = UserDefaultsService().getDate(key: .backgroundTime).getLocalDate()
                if time.addingTimeInterval(SceneDelegate.backroundScreenInterval) < Date().getLocalDate() {
                    self.appCoordinator.runPINVerificationFlow(isFirstShown: false)
                }
            }
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        UserDefaults.setVal(value: Date(), forKey: .backgroundTime)
    }

}
