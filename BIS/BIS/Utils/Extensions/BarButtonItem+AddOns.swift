//
//  BarButtonItem+AddOns.swift
//  BIS
//
//  Created by TSSIOS on 18/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

/// PDF image size : 20px * 20px is perfect one
public typealias ActionHandler = (_ sender: UIButton) -> Void

public extension UIViewController {
    //Back bar with custom action
    func leftBackAction(action: @escaping ActionHandler) {
        self.leftBackBarButton(backImage: #imageLiteral(resourceName: "arrow-back"), action: action)
    }

    func leftBarButtonAction(image: UIImage, action: @escaping ActionHandler) {
        self.leftBackBarButton(backImage: image, action: action)
    }

    func rightBarButtonAction(image: UIImage, action: @escaping ActionHandler) {
        self.rightBarButton(buttonImage: image, action: action)
    }

    func rightBarButtonAction(images: [UIImage], action: @escaping ActionHandler) {
        self.rightBarButtons(buttonImages: images, action: action)
    }
    //Back bar with go to previous action
//    func leftBackToPrevious() {
//        self.leftBackBarButton(backImage: #imageLiteral(resourceName: "arrow-back"), action: nil)
//    }

    //back action
    private func leftBackBarButton(backImage: UIImage, action: @escaping  ActionHandler) {
        guard self.navigationController != nil else {
//            assert(false, "Your target ViewController doesn't have a UINavigationController")
            return
        }

        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(backImage, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        button.imageView!.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .center

        button.ngl_addAction(forControlEvents: .touchUpInside, withCallback: {[weak self] in
            //If custom action ,call back
            if action != nil {
                action(button)
                return
            }

            if self!.navigationController!.viewControllers.count > 1 {
                self!.navigationController?.popViewController(animated: true)
            } else if self!.presentingViewController != nil {
                self!.dismiss(animated: true, completion: nil)
            }
        })

        let barButton = UIBarButtonItem(customView: button)
        let gapItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        gapItem.width = -7  //fix the space
        self.navigationItem.leftBarButtonItems = [gapItem, barButton]
    }

    private func rightBarButton(buttonImage: UIImage, action: @escaping  ActionHandler) {
        guard self.navigationController != nil else {
            //            assert(false, "Your target ViewController doesn't have a UINavigationController")
            return
        }

        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(buttonImage, for: .normal)
        button.frame = CGRect(x: UIScreen.main.bounds.width, y: 0, width: 40, height: 30)
        button.imageView!.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .center

        button.ngl_addAction(forControlEvents: .touchUpInside, withCallback: {
            action(button)
            return
        })

        let barButton = UIBarButtonItem(customView: button)
        let gapItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        gapItem.width = -7  //fix the space
        self.navigationItem.rightBarButtonItems = [gapItem, barButton]
    }

    private func rightBarButtons(buttonImages: [UIImage], action: @escaping  ActionHandler) {
        var barButtons = [UIBarButtonItem]()

        for (index, image) in buttonImages.enumerated() {
            let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
            button.setImage(image, for: .normal)
            button.frame = CGRect(x: Int(UIScreen.main.bounds.width) - (index * 40), y: 0, width: 40, height: 30)
            button.tag = 50000 + index
            button.imageView!.contentMode = .scaleAspectFit
            button.contentHorizontalAlignment = .center

            button.ngl_addAction(forControlEvents: .touchUpInside, withCallback: {
                action(button)
                return
            })

            barButtons.append(UIBarButtonItem(customView: button))
        }

        let gapItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)

        gapItem.width = -7  //fix the space

        self.navigationItem.rightBarButtonItems = [gapItem] + barButtons
    }
}

public extension UINavigationItem {
    //left bar
    func leftButtonAction(image: UIImage, action: @escaping ActionHandler) {
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(image, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        button.imageView!.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .left
        button.ngl_addAction(forControlEvents: .touchUpInside, withCallback: {
            action(button)
        })
        let barButton = UIBarButtonItem(customView: button)
        let gapItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        gapItem.width = -7 //fix the space
        self.leftBarButtonItems = [gapItem, barButton]
    }

    //right bar
    func rightButtonAction(image: UIImage, action: @escaping ActionHandler) {
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(image, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        button.imageView!.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .right
        button.ngl_addAction(forControlEvents: .touchUpInside) {
            action(button)
        }
        let barButton = UIBarButtonItem(customView: button)
        let gapItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        gapItem.width = -7 //fix the space
        self.rightBarButtonItems = [gapItem, barButton]
    }

    func rightButtonActions(images: [UIImage], action: @escaping  ActionHandler) {
        var barButtons = [UIBarButtonItem]()
        for (index, image) in images.enumerated() {
            let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
            button.setImage(image, for: .normal)
            button.frame = CGRect(x: Int(UIScreen.main.bounds.width) - (index * 20), y: 0, width: 40, height: 30)
            button.tag = 50000 + index
            button.imageView!.contentMode = .scaleAspectFit
            button.contentHorizontalAlignment = .center

            button.ngl_addAction(forControlEvents: .touchUpInside, withCallback: {
                action(button)
                return
            })
            barButtons.append(UIBarButtonItem(customView: button))
        }

        let gapItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)

        gapItem.width = -7  //fix the space

        self.rightBarButtonItems = [gapItem] + barButtons
    }
}

/*
 Block of UIControl
*/
public class ClosureWrapper: NSObject {
    let getCallback : () -> Void
    init(callback : @escaping () -> Void) {
        getCallback = callback
    }

    @objc public func invoke() {
        getCallback()
    }
}

var associatedClosure: UInt8 = 0

extension UIControl {
    func ngl_addAction(forControlEvents events: UIControl.Event, withCallback callback: @escaping () -> Void) {
        let wrapper = ClosureWrapper(callback: callback)
        addTarget(wrapper, action: #selector(ClosureWrapper.invoke), for: events)
        objc_setAssociatedObject(self, &associatedClosure, wrapper, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
