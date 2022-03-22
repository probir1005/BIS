//
//  BISSettingsHeaderView.swift
//  BIS
//
//  Created by TSSIOS on 11/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

class BISSettingsHeaderView: UICollectionReusableView, ReuseIdentifier, NibLoadableView {

    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var headingLabelLeadingConstraints: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.insertHorizontalGradient(UIColor.lightGray1, UIColor.white)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
        if !CustomNavigationController.appDelegate.landscape {
            self.headingLabelLeadingConstraints.constant = 20
        } else {
            self.headingLabelLeadingConstraints.constant = 55
        }
        self.layoutIfNeeded()
    }

    func configureView(with dto: SettingsDTO) {
        self.headingLabel.text = dto.heading
        self.insertHorizontalGradient(UIColor.lightGray1, UIColor.white)
    }
}
