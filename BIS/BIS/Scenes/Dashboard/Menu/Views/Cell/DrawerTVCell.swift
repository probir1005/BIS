//
//  DrawerTVCell.swift
//  BIS
//
//  Created by TSSIT on 27/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

class DrawerTVCell: UITableViewCell, ReuseIdentifier, NibLoadableView {

    @IBOutlet weak var menuLabel: UILabel! 
    @IBOutlet weak var arrowImageView: UIImageView! 
    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var disableView: UIView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(menuTitle: String, menuIcon: UIImage, arrowIcon: UIImage) {
        menuLabel.text = menuTitle
        menuImageView.image = menuIcon
        arrowImageView.image = arrowIcon
    }
    
    func configureCell(model: DrawerViewModel) {
        
        menuLabel.text = model.title
        disableView.isHidden = model.title != "Management"
        if model.isSelected {
            menuLabel.textColor = .astronautBlue
            menuImageView.image = model.logoSeletedImage
            arrowImageView.image = (model.arrowImage == nil) ? nil : #imageLiteral(resourceName: "drawerArrowSelected")
        } else {
            menuLabel.textColor = .dodgerBlueDark
            menuImageView.image = model.logoImage
            arrowImageView.image = model.arrowImage
        }
        
        arrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat.zero)
        if model.isExpandable {
            arrowImageView.transform = CGAffineTransform(rotationAngle: model.isExpanded ? CGFloat(Double.pi/2) : CGFloat(-Double.pi/2))
        }
    }
    
}
