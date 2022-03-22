//
//  BISChartHomeCVCell.swift
//  BIS
//
//  Created by TSSIT on 31/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit
import Highcharts

class BISChartHomeCVCell: UICollectionViewCell, ReuseIdentifier, NibLoadableView {

    // MARK: - Outlets and properties:
    weak var expandDelegate: BISDashboardExpandDelegate?
    
    @IBOutlet weak var chartView: HIChartView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var optionButton: UIButton!
    
    // MARK: - View life cycle methods:
    override func awakeFromNib() {
        super.awakeFromNib()  
        self.contentView.addShadow()
    }

    // MARK: - Public methods:
    func configureCell(with JSONString: String, title: String?) {
        titleLabel.text = title
        chartView.destroy()
        if let options = HighChartManager.getHighChart(with: JSONString) {
            chartView.plugins = ["bullet"]
            chartView?.options = options
        }
        chartView.isUserInteractionEnabled = false
    }
    
    // MARK: - Action methods:
    @IBAction func expendButtonTapped(_ sender: Any) {
        expandDelegate?.expandButtonTapped(cell: self)
    }
    
    @IBAction func optionButtonTapped(_ sender: UIButton) {
        expandDelegate?.optionButtonTapped(cell: self)
    }
    
}
