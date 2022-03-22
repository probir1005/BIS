//
//  BISDescriptionCVCell.swift
//  BIS
//
//  Created by TSSIT on 30/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

class BISDescriptionCVCell: UICollectionViewCell, ReuseIdentifier, NibLoadableView {
    
    // MARK: - Outlets and properties:
    weak var expandDelegate: BISDashboardExpandDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var prifitLossImageView: UIImageView!
    @IBOutlet weak var optionButton: UIButton!
    @IBOutlet weak var turnoverStackView: UIStackView!
    
    // MARK: - View life cycle methods:
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.addShadow()
    }

    // MARK: - Public methods:
    func configureCell(model: HomeDescriptionDTO) {

        titleLabel.text = model.title
        descriptionLabel.text = model.description
        prifitLossImageView.image = model.image
        
        for subview in turnoverStackView.arrangedSubviews {
            subview.removeFromSuperview()
        }
        
        if let list = model.turnoverList {
            for turnover in list {
                let label = UILabel()
                label.text = turnover
                label.font = BISFont.bodyText.semibold
                label.textColor = .darkGray1
                label.lineBreakMode = .byWordWrapping
                label.numberOfLines = 0
                
                if turnover != list.last {
                    label.setContentCompressionResistancePriority(.required, for: .horizontal)
                }
                
                turnoverStackView.addArrangedSubview(label)
            }
        }
        
        turnoverStackView.layoutIfNeeded()
    }
    
    // MARK: - Action methods:
    @IBAction func expendButtonTapped(_ sender: Any) {
        expandDelegate?.expandButtonTapped(cell: self)
    }
    
    @IBAction func optionButtonTapped(_ sender: UIButton) {
        expandDelegate?.optionButtonTapped(cell: self)
    }
}
