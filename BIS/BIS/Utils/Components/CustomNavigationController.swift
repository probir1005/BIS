//
//  CustomNavigationController.swift
//  BIS
//
//  Created by TSSIOS on 17/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {

    static let appDelegate = (UIApplication.shared.delegate as! AppDelegate)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBar()
        if let interfaceOrientation = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.windowScene?.interfaceOrientation {
            CustomNavigationController.appDelegate.landscape = interfaceOrientation.isLandscape
        }
        NotificationCenter.default.addObserver(
        self,
        selector: #selector(orientationChanged(notification:)),
        name: UIDevice.orientationDidChangeNotification,
        object: nil)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if drawer() != nil, drawer()!.isMenuOpen {
            drawer()?.closeMenu()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            if traitCollection.userInterfaceStyle == .light {
                return .darkContent
            } else {
                return .lightContent
            }
        } else {
            return .lightContent
        }
    }

    @objc func orientationChanged(notification: NSNotification) {
           //your code there

//        switch UIDevice.current.orientation {
//        case .landscapeLeft, .landscapeRight:
//            if drawer() != nil, drawer()!.isMenuOpen, !CustomNavigationController.appDelegate.landscape {
//                drawer()?.closeMenu()
//            }
//        case .portrait, .portraitUpsideDown:
//            if drawer() != nil, drawer()!.isMenuOpen, CustomNavigationController.appDelegate.landscape {
//                drawer()?.closeMenu()
//            }
//
//        default: break
//        }
    }

    func setupBar() {

        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white, .font: FontType.helveticaNeueMedium.getFont(fontSize: BISFont.h20.rawValue)]
            navBarAppearance.backgroundColor = .clear
            navBarAppearance.backgroundImage = #imageLiteral(resourceName: "navBar")
            self.navigationBar.standardAppearance = navBarAppearance
            self.navigationBar.compactAppearance = navBarAppearance
            self.navigationBar.scrollEdgeAppearance = navBarAppearance
            self.navigationBar.prefersLargeTitles = false
            self.navigationBar.isTranslucent = true
            self.navigationBar.tintColor = .white
            navigationItem.title = title

        } else {
            // Fallback on earlier versions
            self.navigationBar.barTintColor = .clear
            self.navigationBar.tintColor = .white
            self.navigationBar.isTranslucent = false
            self.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "navBar"), for: .default)
            navigationItem.title = title
        }
    }

    func openAnimation (completion: (() -> Void)?) {

        drawer()?.leftViewController.view.trailingConstraint!.constant = CustomNavigationController.appDelegate.landscape ? self.view.frame.width/1.8 : self.view.frame.width/3.5

        UIView.animate(withDuration: customSidePanelAnimationDuration,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
                        [unowned self] in

                        self.view.center.x = CustomNavigationController.appDelegate.landscape ? self.view.frame.width - self.view.frame.width/4 : self.view.frame.width
                        let layer = self.view.layer

                        let transform1 = CATransform3DMakeScale(0.95, 0.95, 1)
                        var transform2 = CATransform3DIdentity
                        transform2.m34 = -1.0 / 700.0
                        transform2 = CATransform3DRotate(transform2, -0.7, 0, 1, 0)
                        layer.transform = CATransform3DConcat(transform1, transform2)
            },
                       completion: { _ in
//                        let keyWindow = UIApplication.shared.connectedScenes
//                        .filter({$0.activationState == .foregroundActive})
//                        .map({$0 as? UIWindowScene})
//                        .compactMap({$0})
//                        .first?.windows
//                        .filter({$0.isKeyWindow}).first
//                        keyWindow?.gestureRecognizers?.removeAll()
//                        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
//                        keyWindow?.addGestureRecognizer(tap)

                        self.view.addShadow(offset: CGSize(width: 1.0, height: 1.0))
                        completion?()
        })
    }

    func closeAnimation (completion: (() -> Void)?) {
        UIView.animate(withDuration: customSidePanelAnimationDuration,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0,
            options: [],
            animations: {
                [unowned self] in

                self.view.frame = UIScreen.main.bounds
                let layer = self.view.layer

                var transform2 = CATransform3DIdentity
                transform2.m34 = -1.0 / 2000.0
                transform2 = CATransform3DRotate(transform2, 1, 0, 0, 0)
                layer.transform = transform2

            },
            completion: { _ in
                completion?()
        })
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if drawer() != nil, drawer()!.isMenuOpen {
            drawer()?.closeMenu()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first {
            if let drawer = self.topMostViewController() as? CustomSidePanel, drawer.isMenuOpen {
                drawer.closeMenu()
            }

            print("point touched: \(touch)")
        }
    }

    // Not giving appropriate result
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        self.closeAnimation(completion: nil)
//        switch UIDevice.current.orientation {
//        case .portrait:
//            CustomNavigationController.appDelegate.landscape = false
//        default:
//            CustomNavigationController.appDelegate.landscape = true
//        }
//    }
}
