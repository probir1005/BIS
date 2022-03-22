//
//  AlertController+AddOns.swift
//  BIS
//
//  Created by TSSIOS on 17/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

typealias AlertActionClosure = ((UIAlertAction) -> Void)

extension UIAlertController {

    @nonobjc
    static func alert(_ title: String?, message: String?, cancelActionTitle: String? = nil, destructiveActionTitle: String? = nil, okAction: AlertActionClosure? = nil, cancelAction: AlertActionClosure? = nil, destructiveAction: AlertActionClosure? = nil) -> UIAlertController {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        //Determination of second action
        let secondTitle = destructiveActionTitle ?? "OK"
        let secondStyle: UIAlertAction.Style = destructiveActionTitle != nil ? .destructive : .default
        let secondAction = destructiveActionTitle != nil ? destructiveAction : okAction

        //Action data in a tuple array
        [(cancelActionTitle, .cancel, cancelAction), (secondTitle, secondStyle, secondAction)]
            .compactMap { (title, style, closure) -> UIAlertAction? in         //Converting to UIAlertAction and removing rows, where title is nil
                guard let safeTitle = title else { return nil }
                return UIAlertAction(title: safeTitle, style: style) { action in closure?(action) }
            }
            .forEach { action in alertController.addAction(action) }            //Adding each action to alertController

        return alertController
    }

    func show() {

        if let alert = UIApplication.shared.topMostViewController() as? UIAlertController {
            alert.dismiss(animated: false, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                UIApplication.shared.topMostViewController()?.present(self, animated: false, completion: nil)
            }
        } else {
            guard let controller = UIApplication.shared.topMostViewController() else {
                return
            }
            controller.present(self, animated: true, completion: nil)
        }
    }
}
