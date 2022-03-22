//
//  ViewController+TabBar.swift
//  BIS
//
//  Created by TSSIOS on 29/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

extension UIViewController {

    func customTabBarController() -> BISTabBarVC? {
        var viewController: UIViewController? = self
        while viewController != nil {
            if viewController is BISTabBarVC {
                return viewController as? BISTabBarVC
            } else if viewController?.parent is CustomSidePanel {
                if ((viewController?.parent as? CustomSidePanel)?.centerViewController) != nil {
                    for controller in ((viewController?.parent as? CustomSidePanel)?.centerViewController.viewControllers)! {
                         if controller is BISTabBarVC {
                            return (viewController?.parent as? CustomSidePanel)?.centerViewController.viewControllers.first as? BISTabBarVC
                        }
                    }
                }
            }
            viewController = viewController?.parent
        }
        return nil
    }

    func customTabBar() -> CustomTabBar? {
        var view: UIView? = self.view
        while view != nil {
            if view is CustomTabBar {
                return view as? CustomTabBar
            }
            view = view?.superview
        }
        return nil
    }
}
