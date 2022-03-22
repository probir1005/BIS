//
//  FilterButton.swift
//  BIS
//
//  Created by TSSIOS on 02/07/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

class FilterButton: UIButton {
    override var isSelected: Bool {
        get { return super.isSelected }
        set {
            super.isSelected = newValue
            self.bringSubviewToFront(superview!)
            self.addshadow(top: true, left: true, bottom: true, right: false, color: UIColor.shadow, hide: !self.isSelected)
        }
    }
}
