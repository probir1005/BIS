//
//  ViewController+SidePanel.swift
//  BIS
//
//  Created by TSSIOS on 29/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

extension UIViewController {

    func drawer() -> CustomSidePanel? {
        var viewController: UIViewController? = self
        while viewController != nil {
            if viewController is CustomSidePanel {
                return viewController as? CustomSidePanel
            }
            viewController = viewController?.parent
        }
        return nil
    }

    func menuController() -> BISMenuVC? {
        var viewController: UIViewController? = self
        while viewController != nil {
            if viewController is BISMenuVC {
                return viewController as? BISMenuVC
            } else if viewController?.parent is CustomSidePanel {
                if ((viewController?.parent as? CustomSidePanel)?.leftViewController) is BISMenuVC {
                    return ((viewController?.parent as? CustomSidePanel)?.leftViewController as! BISMenuVC)
                }
            }
            viewController = viewController?.parent
        }
        return nil
    }
}
