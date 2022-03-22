//
//  BISOptioDropdownCell.swift
//  BIS
//
//  Created by TSSIT on 24/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

class BISOptioDropdownCell: UITableViewCell, ReuseIdentifier, NibLoadableView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var optionImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectedBackgroundView?.isHidden = true
    }

    func configureCell(with title: String, image: UIImage?) {
        titleLabel.text = title
        
        if image == nil {
            optionImageView?.removeFromSuperview()
        } else {
            optionImageView?.image = image
        }
    }
    
}
