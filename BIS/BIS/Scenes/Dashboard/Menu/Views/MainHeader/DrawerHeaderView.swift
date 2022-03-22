//
//  DrawerHeaderView.swift
//  BIS
//
//  Created by TSSIT on 27/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

class DrawerHeaderView: UIView {

    @IBOutlet weak var titleLabel: UILabel! 
    @IBOutlet weak var logoImageView: UIImageView!
    
    func setViewModel(_ title: String, logoImage: UIImage = #imageLiteral(resourceName: "loginLogo")) {
        titleLabel.text = title
        logoImageView.image = logoImage
    }

}
