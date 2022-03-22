//
//  BaseViewController.swift
//  BIS
//
//  Created by TSSIOS on 18/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var layerView: CustomLayerView?
    let networkingManager = NetworkingManager()
    private var catchScreenShotNotification: NSObjectProtocol?
    private var catchScreenRecNotification: NSObjectProtocol?

    // This extends the superclass.
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupDependencyConfigurator()
    }

    // This is also necessary when extending the superclass.
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupDependencyConfigurator()
    }

    func setupDependencyConfigurator() {
        if self is BISSignInVC {
            OrientationLock.lockOrientation(.portrait, andRotateTo: .portrait)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        catchScreenShotNotification = NotificationCenter.default.addObserver(
          forName: UIApplication.userDidTakeScreenshotNotification,
          object: nil, queue: nil) { _ in
            print("I see what you did there")
        }

        catchScreenRecNotification = NotificationCenter.default.addObserver(
            forName: UIScreen.capturedDidChangeNotification,
          object: nil, queue: nil) { _ in
            self.layerView = CustomLayerView(frame: UIScreen.main.bounds)
            if UIScreen.main.isCaptured {
                self.layerView?.showLayer()
            } else {

                if self.layerView != nil {
                    self.layerView?.removeLayer()
                    self.layerView = nil
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self is BISSignInVC || self is BISVerifyOTPVC {
            OrientationLock.lockOrientation(.portrait, andRotateTo: .portrait)
            NotificationCenter.default.addObserver(
            self,
            selector: #selector(rotationChanged(notification:)),
            name: UIDevice.orientationDidChangeNotification,
            object: nil)
        }
//        else if self is BISPINRegisterVC || self is BISHelpVC {
//            if CustomNavigationController.appDelegate.deviceOrietation == .landscapeLeft {
//                OrientationLock.lockOrientation(.all, andRotateTo: .landscapeLeft)
//            } else if CustomNavigationController.appDelegate.deviceOrietation == .landscapeRight {
//                 OrientationLock.lockOrientation(.all, andRotateTo: .landscapeRight)
//            } else {
//                OrientationLock.lockOrientation(.all, andRotateTo: .portrait)
//            }
//        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self is BISSignInVC || self is BISVerifyOTPVC {
            OrientationLock.lockOrientation(.allButUpsideDown)
            NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
        }
//        else if self is BISHelpVC || self is BISPINRegisterVC {
//            OrientationLock.lockOrientation(.portrait, andRotateTo: .portrait)
//        }
    }

    deinit {
        NotificationCenter.default.removeObserver(catchScreenRecNotification as Any)
        NotificationCenter.default.removeObserver(catchScreenShotNotification as Any)
    }

    @objc func rotationChanged(notification: NSNotification) {
           //your code there
        if self is BISSignInVC || self is BISVerifyOTPVC {
            switch UIDevice.current.orientation {
            case .landscapeLeft:
                CustomNavigationController.appDelegate.deviceOrietation = .landscapeLeft
            case .landscapeRight:
                CustomNavigationController.appDelegate.deviceOrietation = .landscapeRight
            default: CustomNavigationController.appDelegate.deviceOrietation = .portrait
            }
        }
    }

    override open var shouldAutorotate: Bool {
        return true
    }

    var screenTitle: String = "" {
        didSet {
            if !self.screenTitle.isEmpty {
                self.navigationItem.title = self.screenTitle
            }
        }
    }

   // MARK: - Dismiss Keyboard

    var shouldDismissKeyboardOnViewTap: Bool = false {
        didSet {
            if self.shouldDismissKeyboardOnViewTap {
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
                tap.cancelsTouchesInView = false
                self.view.addGestureRecognizer(tap)
            }
        }
    }

    @objc
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func showAlert(title: String? = nil, message: String, primaryButtonName: String? = "OK", primaryActionHandler: (() -> Void)? = nil, isDestructive: Bool = false, secondButtonName: String? = nil, secondAction: (() -> Void)? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if secondButtonName != nil {
            let secondaryAction = UIAlertAction(title: secondButtonName, style: .default) { (_) in
                secondAction?()
            }
            alertController.addAction(secondaryAction)
        }
        
        let primaryAction = UIAlertAction(title: primaryButtonName, style: isDestructive ? .destructive : .default) { (_) in
            primaryActionHandler?()
        }
        alertController.addAction(primaryAction)
        alertController.preferredAction = primaryAction
        self.present(alertController, animated: true, completion: nil)
    }
}
