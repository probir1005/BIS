//
//  BISTableCVCell.swift
//  BIS
//
//  Created by TSSIT on 16/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

class BISTableCVCell: UICollectionViewCell, ReuseIdentifier, NibLoadableView {
    
    // MARK: - Outlets and properties:
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var spreadSheetView: BISSpreadSheetView!
    @IBOutlet weak var optionButton: UIButton!
    
    weak var expandDelegate: BISDashboardExpandDelegate?
    
    // MARK: - View life cycle methods:
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.addShadow()
        // Initialization code
    }
    
    // MARK: - Public methods:
    func configureCell(title: String, tableModel: TableDetailsModel) {
        titleLabel.text = title
        spreadSheetView.tableDetails = tableModel
    }

    // MARK: - Action methods:
    @IBAction func expandButtonTapped(_ sender: Any) {
        expandDelegate?.expandButtonTapped(cell: self)
    }
    
    @IBAction func optionButtonTapped(_ sender: UIButton) {
        expandDelegate?.optionButtonTapped(cell: self)
    }
}
