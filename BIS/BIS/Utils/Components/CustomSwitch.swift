//
//  CustomSwitch.swift
//  BIS
//
//  Created by TSSIOS on 12/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

@IBDesignable class CustomSwitch: UISwitch {

    @IBInspectable var scale: CGFloat = 0.0 {
        didSet {
            setup()
        }
    }

    //from storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    //from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        self.transform = CGAffineTransform(scaleX: scale, y: scale)
    }

    override func prepareForInterfaceBuilder() {
        setup()
        super.prepareForInterfaceBuilder()
    }

}
