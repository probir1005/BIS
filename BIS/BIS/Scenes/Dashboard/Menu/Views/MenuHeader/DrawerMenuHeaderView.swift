//
//  DrawerMenuHeaderView.swift
//  BIS
//
//  Created by TSSIT on 28/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

protocol DrawerMenuHeaderDelegate: class {
    func headerTapped(at index: Int)
}

class DrawerMenuHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var menuLabel: UILabel! 
    @IBOutlet weak var arrowImageView: UIImageView! 
    @IBOutlet weak var menuImageView: UIImageView! 
    
//    var model: DrawerViewModel?
    var index: Int = 0
    weak var delegate: DrawerMenuHeaderDelegate?

    func configureView(model: DrawerViewModel, index: Int) {
        
        self.index = index
        menuLabel.text = model.title

        if model.isSelected {
            menuLabel.textColor = .astronautBlue
            menuImageView.image = model.logoSeletedImage
            if model.isExpandable {
                arrowImageView.alpha = 0.1
            } else {
                arrowImageView.alpha = 1.0
            }
            arrowImageView.image = (model.arrowImage == nil) ? nil : #imageLiteral(resourceName: "drawerArrowSelected")
        } else {
            menuLabel.textColor = .dodgerBlueDark
            menuImageView.image = model.logoImage
            arrowImageView.image = model.arrowImage
        }
        
        arrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat.zero)
        // Dirty Hack will remove once get the actual solution
        if model.isExpandable {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: .curveEaseInOut, animations: { [weak self] in
                    if model.isExpanded {
                        self?.arrowImageView.transform = CGAffineTransform(rotationAngle: -CGFloat(Double.pi/2))
                    } else if self?.arrowImageView.image == #imageLiteral(resourceName: "drawerArrowForward") && !model.isSelected {
                        self?.arrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
                    }
                    self?.arrowImageView.alpha = 1.0

                    self?.layoutSubviews()
                    self?.layoutIfNeeded()
                    }, completion: { _ in
                        self.arrowImageView.image = model.isExpanded ? #imageLiteral(resourceName: "drawerArrowSelected") : self.arrowImageView.image == #imageLiteral(resourceName: "drawerArrowForward") ? #imageLiteral(resourceName: "drawerArrowForward") : #imageLiteral(resourceName: "arrowDown")
                })
            }
        }
    }
    
    @IBAction func headerTapped(sender: Any) {
        delegate?.headerTapped(at: index)
    }
}
