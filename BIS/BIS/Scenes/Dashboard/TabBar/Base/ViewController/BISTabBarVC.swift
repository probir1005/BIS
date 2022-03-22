//
//  BISTabBarVC.swift
//  BIS
//
//  Created by TSSIOS on 26/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

protocol BISTabBarVCProtocol: class {
    var onNextStep: (() -> Void)? { get set }
    var onHome: (() -> Void)? { get set }
    var onFavourites: (() -> Void)? { get set }
    var onAlerts: (() -> Void)? { get set }
    var onSettings: (() -> Void)? { get set }
    var onFinish: (() -> Void)? { get set }
//    var presenter: TabBarPresenterProtocol? { get set }
//    var interactor: TabBarInteractorProtocol? { get set }

    // Update UI with value returned.
//    func setInitialView()
}

class BISTabBarVC: BaseViewController, BISTabBarVCProtocol, UIGestureRecognizerDelegate {

    // MARK: - Properties

//    var presenter: PINRegisterPresenterProtocol?
//    var interactor: PINRegisterInteractorProtocol?
    var onNextStep: (() -> Void)?
    var onFavourites: (() -> Void)?
    var onAlerts: (() -> Void)?
    var onSettings: (() -> Void)?
    var onHome: (() -> Void)?
    var onFinish: (() -> Void)?

    var controllerArray: [CustomNavigationController]
    var selectedController: CustomNavigationController!
    let initialIndex = 0
    var isTabBarHidden = Bool()
//    var initialTabBarHeight: CGFloat = 0.0
    var selectedTabIndex: Int = 0
    
    // MARK: - Outlets
    @IBOutlet weak var tabBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tabBar: CustomTabBar!
    @IBOutlet weak var controllerManagerView: UIView!

    // MARK: - Initialization

    init(controllers: [CustomNavigationController]) {
        self.controllerArray = controllers
        super.init(nibName: String(describing: BISTabBarVC.self), bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            // This is called during the animation
            self.orientationChange()
        }, completion: nil)
    }

    // MARK: - Private Methods
    private func orientationChange() {
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            CustomNavigationController.appDelegate.landscape = true
            self.tabBar.heightConstraint?.constant = self.isTabBarHidden ? 0.0 : UIDevice.current.hasNotch ? 70 : 60
        case .portrait, .portraitUpsideDown:
            CustomNavigationController.appDelegate.landscape = false
            self.tabBar.heightConstraint?.constant = self.isTabBarHidden ? 0.0 : UIDevice.current.hasNotch ? 90 : 70//self.tabBar.heightConstraint?.constant ?? 0
        default:
            break
        }
    }

    private func initialize() {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarHeightConstraint.constant = self.isTabBarHidden ? 0.0 :  CustomNavigationController.appDelegate.landscape ? UIDevice.current.hasNotch ? 70 : 60 : UIDevice.current.hasNotch ? 90 : 70
        self.tabBar.tabBarDelegate = self
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.setSelectedController(index: self.initialIndex)
        }
    }

    private func hideWithAlpha(isHide: Bool) {
        UIView.animate(withDuration: 0.4, animations: {
            self.tabBar.alpha = isHide ? 0.0 : 1.0
        }, completion: { _ in
            self.isTabBarHidden = isHide
        })
    }

    private func hideWithSpringAnimation(isHide: Bool) {

        if isHide {
            self.tabBarHeightConstraint.constant = 0.0
        } else {
            self.tabBarHeightConstraint.constant =  CustomNavigationController.appDelegate.landscape ? UIDevice.current.hasNotch ? 70 : 60 : UIDevice.current.hasNotch ? 90 : 70
        }

        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: .curveEaseInOut, animations: { [weak self] in
            self?.view.layoutIfNeeded()
            }, completion: { _ in
                self.isTabBarHidden = isHide
        })
    }

    private func setupSelectedController() {
        self.selectedController.view.frame = controllerManagerView.bounds
        self.controllerManagerView.addSubview(selectedController.view)
        self.addChild(selectedController)
        self.selectedController.didMove(toParent: self)
        self.selectedController.isNavigationBarHidden = false
        self.view.endEditing(true)

        //Optional if required
//        if self.selectedController.viewControllers.count > 1 {
//            self.selectedController.popToRootViewController(animated: false)
//        }
    }

    // MARK: - Public Methods
    public func setSelectedController(index: Int) {
        self.tabBar.setSelectedIndex(index: index, completion: nil)
        for subview in controllerManagerView.subviews {
            subview.removeFromSuperview()
        }

        self.selectedTabIndex = index
        self.menuController()?.dataSource = DrawerViewModel.getDrawerViewModel()

        self.menuController()?.selectedModel = DrawerViewModel.getDrawerViewModel().filter { $0.isSelected }.first
        self.menuController()?.menuTableView.reloadData()

        self.selectedController = self.controllerArray[index]

        self.setupSelectedController()
    }

    public func hideTabBar(isHide: Bool) {
        self.hideWithSpringAnimation(isHide: isHide)
    }
}

    // MARK: - Extension
extension BISTabBarVC: CustomTabBarProtocol {

    func tabBarButtonClickAt(index: Int) {
        self.setSelectedController(index: index)
    }

}
