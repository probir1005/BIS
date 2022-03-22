//
//  BISFilterTVCell.swift
//  BIS
//
//  Created by TSSIOS on 03/07/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

class BISFilterTVCell: UITableViewCell, ReuseIdentifier, NibLoadableView {

    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var separatorLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    var dto: ItemFilterDTO!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(with dto: ItemFilterDTO, isLast: Bool) {
        self.dto = dto

        self.nameLabel.text = dto.title
        self.separatorLabel.isHidden = isLast
        self.selectButton.isSelected = dto.isSelected
    }
    
}
