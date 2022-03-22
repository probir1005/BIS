//
//  BISAboutUsVC.swift
//  BIS
//
//  Created by TSSIOS on 12/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

protocol AboutUsVCProtocol: class {
    var onError: (() -> Void)? { get set }
    var onFinish: (() -> Void)? { get set }
    var onBack: (() -> Void)? { get set }
    var onTandC: ((_ title: String) -> Void)? { get set }
}

class BISAboutUsVC: BaseViewController, AboutUsVCProtocol {

    var onError: (() -> Void)?
    var onFinish: (() -> Void)?
    var onBack: (() -> Void)?
    var onTandC: ((_ title: String) -> Void)?

    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var aboutUsInfoLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenTitle = "About Us"
        self.leftBackAction { _ in
            self.onBack?()
        }
        self.setContent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customTabBarController()?.hideTabBar(isHide: true)
    }

    @IBAction func termsButtonAction(_ sender: UIButton) {
        self.onTandC?("Terms & Conditions")
    }

    func setContent() {
        self.versionLabel.text = "Version 1.0.0"
        self.aboutUsInfoLabel.text = "At Kuoni Tumlare, we create truly inspiring travel experiences that go beyond expectations. Proudly part of the JTB Corporation, we curate and deliver group travel, and meetings, incentives, congresses and events (MICE).\nTrading under the brands JTB, Kuoni Global Travel Services, Tumlare Destination Management, Kuoni Destination Management, Kuoni Congress and Conference & Touring, our 3,000 plus team members are located across 34 countries throughout Europe, Asia Pacific and the Americas."
    }
    
}
