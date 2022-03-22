//
//  Navigater.swift
//  BIS
//
//  Created by TSSIOS on 14/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

protocol Presentable {
    func toPresent() -> UIViewController?
}

protocol NavigaterProtocol: Presentable {

    func present(_ module: Presentable?)
    func present(_ module: Presentable?, animated: Bool)
    func present(_ module: Presentable?, animated: Bool, modalStyle: UIModalPresentationStyle)

    func push(_ module: Presentable?, hideNavBar: Bool)
    func push(_ module: Presentable?, transition: UIViewControllerAnimatedTransitioning?, hideNavBar: Bool)
    func push(_ module: Presentable?, transition: UIViewControllerAnimatedTransitioning?, animated: Bool, hideNavBar: Bool)
    func push(_ module: Presentable?, transition: UIViewControllerAnimatedTransitioning?, animated: Bool, hideNavBar: Bool, completion: (() -> Void)?)

    func popModule(hideNavBar: Bool)
    func popModule(hideNavBar: Bool, transition: UIViewControllerAnimatedTransitioning?)
    func popModule(hideNavBar: Bool, transition: UIViewControllerAnimatedTransitioning?, animated: Bool)

    func dismissModule()
    func dismissModule(animated: Bool, completion: (() -> Void)?)

    func setRootModule(_ module: Presentable?)
    func setRootModule(_ module: Presentable?, hideNavBar: Bool)

    func popToRootModule(hideNavBar: Bool, animated: Bool)
    func popToModule(hideNavBar: Bool, module: Presentable?, animated: Bool)
    var rootNavController: UINavigationController? { get set }
}

final class Navigater: NSObject, NavigaterProtocol {

    // MARK: - Vars & Lets
    var rootNavController: UINavigationController?
    private weak var rootController: UINavigationController?
    private var completions: [UIViewController : () -> Void]
    private var transition: UIViewControllerAnimatedTransitioning?

    // MARK: - Presentable

    func toPresent() -> UIViewController? {
        return self.rootController
    }

    // MARK: - RouterProtocol

    func present(_ module: Presentable?) {
        present(module, animated: true)
    }

    func present(_ module: Presentable?, animated: Bool) {
        guard let controller = module?.toPresent() else { return }
        self.rootController?.present(controller, animated: animated, completion: {
            controller.presentationController?.presentedView?.gestureRecognizers?[0].delegate = controller as? UIGestureRecognizerDelegate
        })
    }

    func present(_ module: Presentable?, animated: Bool, modalStyle: UIModalPresentationStyle) {
        guard let controller = module?.toPresent() else { return }
        controller.modalPresentationStyle = modalStyle
        self.rootController?.present(controller, animated: animated, completion: nil)
    }

    func push(_ module: Presentable?, hideNavBar: Bool) {
        self.push(module, transition: nil, hideNavBar: hideNavBar)
    }

    func push(_ module: Presentable?, transition: UIViewControllerAnimatedTransitioning?, hideNavBar: Bool) {
        self.push(module, transition: transition, animated: true, hideNavBar: hideNavBar)
    }

    func push(_ module: Presentable?, transition: UIViewControllerAnimatedTransitioning?, animated: Bool, hideNavBar: Bool) {
        self.push(module, transition: transition, animated: animated, hideNavBar: hideNavBar, completion: nil)
    }

    func push(_ module: Presentable?, transition: UIViewControllerAnimatedTransitioning?, animated: Bool, hideNavBar: Bool, completion: (() -> Void)?) {
        DispatchQueue.main.async {
            self.transition = transition
            guard let controller = module?.toPresent(),
                (controller is UINavigationController == false)
                else { assertionFailure("Deprecated push UINavigationController."); return }

            if let completion = completion {
                self.completions[controller] = completion
            }
            controller.modalPresentationStyle = .fullScreen
            self.rootController?.isNavigationBarHidden = hideNavBar
            self.rootController?.pushViewController(controller, animated: animated)
        }
    }

    func popModule(hideNavBar: Bool) {
        self.popModule(hideNavBar: hideNavBar, transition: nil)
    }

    func popModule(hideNavBar: Bool, transition: UIViewControllerAnimatedTransitioning?) {
        self.popModule(hideNavBar: hideNavBar, transition: transition, animated: true)
    }

    func popModule(hideNavBar: Bool, transition: UIViewControllerAnimatedTransitioning?, animated: Bool) {
        self.transition = transition
        self.rootController?.isNavigationBarHidden = hideNavBar
        if let controller = rootController?.popViewController(animated: animated) {
            self.runCompletion(for: controller)
        }
    }

    func popToModule(hideNavBar: Bool, module: Presentable?, animated: Bool) {
        DispatchQueue.main.async {
            self.rootController?.isNavigationBarHidden = hideNavBar
            if let controllers = self.rootController?.viewControllers, let module = module {
                for controller in controllers {
                    if controller == module as! UIViewController {
                        self.rootController?.popToViewController(controller, animated: animated)
                        break
                    }
                }
            }
        }
    }

    func dismissModule() {
        self.dismissModule(animated: true, completion: nil)
    }

    func dismissModule(animated: Bool, completion: (() -> Void)?) {
        self.rootController?.dismiss(animated: animated, completion: completion)
    }

    func setRootModule(_ module: Presentable?) {
        self.setRootModule(module, hideNavBar: false)
    }

    func setRootModule(_ module: Presentable?, hideNavBar: Bool) {
        guard let controller = module?.toPresent() else { return }
        self.rootController?.setViewControllers([controller], animated: false)
        self.rootController?.isNavigationBarHidden = hideNavBar
    }

    func popToRootModule(hideNavBar: Bool, animated: Bool) {
        self.rootController?.isNavigationBarHidden = hideNavBar
        if let controllers = self.rootController?.popToRootViewController(animated: animated) {
            controllers.forEach { controller in
                self.runCompletion(for: controller)
            }
        }
    }

    // MARK: - Private methods

    private func runCompletion(for controller: UIViewController) {
        guard let completion = self.completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }

    // MARK: - Init methods

    init(rootController: UINavigationController) {
        self.rootController = rootController
        self.rootNavController = self.rootController
        self.completions = [:]
        super.init()
        self.rootController?.delegate = self
    }
}

// MARK: - Extensions
// MARK: - UINavigationControllerDelegate

extension Navigater: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.transition
    }

}
