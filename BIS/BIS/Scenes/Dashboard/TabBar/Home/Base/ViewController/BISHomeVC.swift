//
//  BISHomeVC.swift
//  BIS
//
//  Created by TSSIOS on 29/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

protocol HomeVCProtocol: class {
    var onFinish: (() -> Void)? { get set }
    var onFilter: (() -> Void)? { get set }

    var presenter: HomePresenterProtocol? { get set }
    var interactor: HomeInteractorProtocol? { get set }

    func setUpView(withControllers controllers: [(viewController: UIViewController, title: String)])
}

class BISHomeVC: BaseViewController, HomeVCProtocol {

    var presenter: HomePresenterProtocol?
    var interactor: HomeInteractorProtocol?

    var onFinish: (() -> Void)?
    var onFilter: (() -> Void)?

//    lazy fileprivate var pages: [(viewController: UIViewController, title: String)] = self.configPages()
    var pages: [(viewController: UIViewController, title: String)] = []
    var customPageViewController: CustomPageViewController?

    var assistiveZoomButton: AssistiveZoomButton = AssistiveZoomButton.init(frame: CGRect.init(x: -5, y: (UIApplication.shared.windows.first {$0.isKeyWindow }?.safeAreaInsets.top ?? 0) + 100, width: 60, height: 60))

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setUpAssistiveButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.assistiveZoomButton.isHidden = !UserDefaultsService().getBool(key: .enableAssistiveZoom)
        if customPageViewController != nil {
            customPageViewController?.tabView.orientationChanged(notification: NSNotification(name: UIDevice.orientationDidChangeNotification, object: nil))
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.assistiveZoomButton.isHidden = true
        self.assistiveZoomButton.isSelected = false
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

    @objc func orientationChanged(notification: NSNotification) {
        self.assistiveZoomButton.frame.origin = CGPoint(x: -5, y: (UIApplication.shared.windows.first {$0.isKeyWindow }?.safeAreaInsets.top ?? 0) + 100)
    }
    
    func setUpView(withControllers controllers: [(viewController: UIViewController, title: String)]) {
        self.pages = controllers
        customPageViewController = CustomPageViewController(pages: controllers)
        self.configPageControllerProperties(customPageViewController: customPageViewController!)
    }

    private func setUpAssistiveButton() {

        customTabBarController()?.view.addSubview(self.assistiveZoomButton)
        customTabBarController()?.view.bringSubviewToFront(self.assistiveZoomButton)
        self.assistiveZoomButton.assistiveZoomButtonAction { _ in
            self.customTabBarController()?.hideTabBar(isHide: self.assistiveZoomButton.isSelected)
            self.navigationController?.setNavigationBarHidden(self.assistiveZoomButton.isSelected, animated: true)
        }

//        UserDefaults.standard.set(true, forKey: "Beta")
    }

    private func setup() {
        self.screenTitle = "Home"
        self.rightBarButtonAction(image: #imageLiteral(resourceName: "filter")) { _ in
            self.onFilter?()
        }
        
        self.leftBarButtonAction(image: #imageLiteral(resourceName: "hamburger-menu")) { _ in
            self.drawer()?.openMenu()
        }

        self.interactor?.fetchDashboardItems()
        NotificationCenter.default.addObserver(
        self,
        selector: #selector(orientationChanged(notification:)),
        name: UIDevice.orientationDidChangeNotification,
        object: nil)
    }

    private func configPageControllerProperties(customPageViewController: CustomPageViewController) {
        customPageViewController.isInfinity = false
        customPageViewController.option.tabWidth = (view.frame.width / CGFloat(pages.count))
        customPageViewController.option.hidesTopViewOnSwipeType = .none
        customPageViewController.option.tabHeight = 50
        customPageViewController.option.isTranslucent = false
        customPageViewController.option.fontSize = 14
        customPageViewController.option.defaultColor = UIColor.darkGray2
        customPageViewController.option.currentColor = UIColor.dodgerBlueLight
        self.addPageControllerToSelf(customPageViewController: customPageViewController)
    }

    private func addPageControllerToSelf(customPageViewController: CustomPageViewController) {
        self.addChildViewController(childController: customPageViewController, onView: self.view)
        self.view.endEditing(true)
    }

}
