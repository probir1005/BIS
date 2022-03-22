//
//  AppDelegate.swift
//  BIS
//
//  Created by TSSIOS on 04/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import SecureDefaults
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var landscape = Bool()
    var orientationLock = UIInterfaceOrientationMask.allButUpsideDown
    var deviceOrietation: UIDeviceOrientation?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        NotificationCenter.default.addObserver(
        self,
        selector: #selector(rotationChanged(notification:)),
        name: UIDevice.orientationDidChangeNotification,
        object: nil)

        return true
    }

    @objc func rotationChanged(notification: NSNotification) {
        //your code there
        switch UIDevice.current.orientation {
        case .landscapeLeft:
            deviceOrietation = .landscapeLeft
            CustomNavigationController.appDelegate.landscape = true

        case .landscapeRight:
            deviceOrietation = .landscapeRight
            CustomNavigationController.appDelegate.landscape = true
        default: CustomNavigationController.appDelegate.landscape = false

        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: Orientation

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return orientationLock
    }

    //Indicator View
    func InitializeIndicatorView(message: String) {
        IndicatorView.spinnerStyle(.spinningFadeCircle)
        IndicatorView.spinnerColor(.darkText)
        IndicatorView.statusTextColor(.darkText)
        IndicatorView.backGroundColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2978378081))
        IndicatorView.spinnerContainerViewColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6974581866))
        IndicatorView.show(message, userInteractionStatus: false)
    }
    
    // keywindow
    static func getKeyWindow() -> UIWindow? {
        let window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first

        return window
    }
}
