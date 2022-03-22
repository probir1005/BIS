//
//  CustomSidePanel.swift
//  BIS
//
//  Created by TSSIOS on 26/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

let customSidePanelAnimationDuration: TimeInterval = 0.5

protocol CustomSidePanelProtocol: class {
    var onFinish: (() -> Void)? { get set }
    var onTabBar: (() -> Void)? { get set }
    var onReport: ((_ data: [Any]) -> Void)? { get set }
}

@objc protocol CustomSidePanelDelegate {

    @objc optional func customSidePanelWillOpenMenu (customSidePanel: CustomSidePanel)
    @objc optional func customSidePanelDidOpenMenu (customSidePanel: CustomSidePanel)

    @objc optional func customSidePanelWillCloseMenu (customSidePanel: CustomSidePanel)
    @objc optional func customSidePanelDidCloseMenu (customSidePanel: CustomSidePanel)

}

class CustomSidePanel: BaseViewController, CustomSidePanelProtocol {
    var onFinish: (() -> Void)?
    var onTabBar: (() -> Void)?
    var onReport: ((_ data: [Any]) -> Void)?

    // MARK: Properties
    public var centerViewController: CustomNavigationController!
    public var leftViewController: UIViewController

    internal var centerContainerView = UIView(frame: .zero)

    var drawerDelegate: CustomSidePanelDelegate?
    var isMenuOpen = Bool()

    // MARK: Initializer
    public init(center: CustomNavigationController, left: UIViewController) {

        centerViewController = center
        leftViewController = left
        super.init(nibName: nil, bundle: nil)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }

    // MARK: Private

    private func setupViews() {

        view.backgroundColor = .white

        // MainViewController
        centerContainerView.frame = view.frame
        //        centerContainerView.backgroundColor = .red
        centerContainerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.addSubview(centerContainerView)
        centerViewController.willMove(toParent: self)
        addChild(centerViewController)
        centerViewController.view.frame = view.frame
        centerContainerView.addSubview(centerViewController.view)
        centerViewController.didMove(toParent: self)
        centerViewController.viewControllers.first!.leftBarButtonAction(image: #imageLiteral(resourceName: "hamburger-menu")) { _ in
            self.openMenu()
        }

        // LeftViewController
        leftViewController.willMove(toParent: self)
        addChild(leftViewController)
        leftViewController.view.frame = view.frame
        view.addSubview(leftViewController.view)
        leftViewController.didMove(toParent: self)
        view.sendSubviewToBack(leftViewController.view)

    }

    // MARK: Public
    public func replace(center controller: UIViewController) {
        centerViewController.willMove(toParent: nil)
        centerViewController.view.removeFromSuperview()
        centerViewController.removeFromParent()
        centerViewController.viewControllers.removeAll()
        centerViewController.addChild(controller)
        centerViewController.willMove(toParent: self)
        addChild(centerViewController)
        centerViewController.view.frame = view.frame
        centerContainerView.addSubview(centerViewController.view)
        centerViewController.didMove(toParent: self)

//        centerViewController = controller
//        centerViewController.viewControllers.first!.willMove(toParent: self)
//        centerViewController.view.addSubview(controller.view)
//        controller.view.bounds = centerViewController.view.frame
//
//        centerViewController.didMove(toParent: self)
//        centerViewController.isNavigationBarHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.centerViewController.viewControllers.first!.topMostViewController().leftBarButtonAction(image: #imageLiteral(resourceName: "hamburger-menu")) { _ in
                self.openMenu()
            }
        }
    }

    // MARK: Interaction

    func openMenu (completion: (() -> Void)? = nil) {

        drawerDelegate?.customSidePanelWillOpenMenu?(customSidePanel: self)
        centerViewController.view.isUserInteractionEnabled = false
        centerContainerView.isUserInteractionEnabled = false
        centerViewController.openAnimation {
            self.isMenuOpen = true
            self.drawerDelegate?.customSidePanelDidOpenMenu?(customSidePanel: self)
            completion?()
        }

    }

    func closeMenu (completion: (() -> Void)? = nil) {

        drawerDelegate?.customSidePanelWillCloseMenu?(customSidePanel: self)

        centerViewController.view.isUserInteractionEnabled = true
        centerContainerView.isUserInteractionEnabled = true
        centerViewController.closeAnimation {
            self.isMenuOpen = false
            self.drawerDelegate?.customSidePanelDidCloseMenu?(customSidePanel: self)
            completion?()
        }
    }

}
