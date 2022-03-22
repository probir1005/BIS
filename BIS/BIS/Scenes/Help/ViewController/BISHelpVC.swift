//
//  BISHelpVC.swift
//  BIS
//
//  Created by TSSIOS on 15/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

protocol HelpRouter: class {
    var onFinish: (() -> Void)? { get set }
    var onBack: (() -> Void)? { get set }
}

class BISHelpVC: BaseViewController, HelpRouter {
    
    // MARK: - Help Router:
    var onFinish: (() -> Void)?
    var onBack: (() -> Void)?

    // MARK: - Outlets and properties:
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    // MARK: - View Controller life cycle methods:
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.ScreenTitle.help
        initializeView()
    }
    
    // MARK: - Private methods
    private func initializeView() {
        self.leftBackAction { _ -> Void in
            self.onBack?()
        }
        self.headingLabel.text = Strings.HelpVC.heading
        self.contentTextView.text = Strings.HelpVC.descriptions
    }
    
    // MARK: - Action Methods
    @IBAction func checkButtonTapped(_ sender: UIButton) {
        self.onFinish?()
    }

}
