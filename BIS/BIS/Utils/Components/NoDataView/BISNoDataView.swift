//
//  BISNoDataView.swift
//  BIS
//
//  Created by TSSIT on 24/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

@IBDesignable
class BISNoDataView: UIView {
    
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var subtitleLable: UILabel!
    
    @IBInspectable var title: String = "" {
        didSet {
            setup()
        }
    }
    
    @IBInspectable var subtitle: String = "" {
        didSet {
            setup()
        }
    }
    
    private func setup() {
        titleLable.text = title
        subtitleLable.text = subtitle
    }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        print(rect)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }

}
