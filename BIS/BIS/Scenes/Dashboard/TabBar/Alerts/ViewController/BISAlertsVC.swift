//
//  BISAlertsVC.swift
//  BIS
//
//  Created by TSSIOS on 29/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

protocol AlertsVCProtocol {
    var onFinish: (() -> Void)? { get set }
}

class BISAlertsVC: BaseViewController, AlertsVCProtocol {

    // MARK: - AlertsVCProtocol:
    var onFinish: (() -> Void)?

    // MARK: - View Controller life cycle methods:
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenTitle = Strings.ScreenTitle.alerts
        self.leftBarButtonAction(image: #imageLiteral(resourceName: "hamburger-menu")) { _ in 
            self.drawer()?.openMenu()
        }
    }
}
