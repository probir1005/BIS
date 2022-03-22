//
//  NavigationController+AddOns.swift
//  BIS
//
//  Created by TSSIOS on 10/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    override open var shouldAutorotate: Bool {
        if let visibleVC = visibleViewController {
            return visibleVC.shouldAutorotate
        }
        return super.shouldAutorotate
    }
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        if let visibleVC = visibleViewController {
            return visibleVC.preferredInterfaceOrientationForPresentation
        }
        return super.preferredInterfaceOrientationForPresentation
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let visibleVC = visibleViewController {
            return visibleVC.supportedInterfaceOrientations
        }
        return super.supportedInterfaceOrientations
    }
}

extension UINavigationItem {
    
    func setTitle(title: String, subtitle: String, isLandscape: Bool) {
        let one = UILabel()
        one.text = title
        one.textColor = .white
        one.font = FontType.robotoMedium.getFont(fontSize: 20.0)
        one.sizeToFit()
        
        let two = UILabel()
        two.text = subtitle
        two.textColor = .white
        two.font = FontType.robotoRegular.getFont(fontSize: 15.0)
        two.textAlignment = .center
        two.sizeToFit()
        
        if isLandscape {
            one.font = FontType.robotoMedium.getFont(fontSize: 17.0)
            two.font = FontType.robotoRegular.getFont(fontSize: 12.0)
        } 
        
        let stackView = UIStackView(arrangedSubviews: [one, two])
        stackView.distribution = .equalCentering
        stackView.axis = .vertical
        stackView.alignment = .center
        
        let width = max(one.frame.size.width, two.frame.size.width)
        stackView.frame = CGRect(x: 0, y: 0, width: width, height: 35)
        
        self.titleView = stackView
    }
}
