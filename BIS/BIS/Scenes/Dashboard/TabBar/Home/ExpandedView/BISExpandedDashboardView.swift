//
//  ExpandedView.swift
//  BIS
//
//  Created by TSSIT on 09/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit
import Highcharts

protocol BISExpandedDashboardViewDelegate: class {
    func collapseButtonTaaped()
    func optionButtonTapped(sender: UIButton)
}

class BISExpandedDashboardView: UIView {

    // MARK: - Outlets and properties:
    weak var collapseDelegate: BISExpandedDashboardViewDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var chartView: HIChartView!
    @IBOutlet weak var profitLossImageView: UIImageView!
    @IBOutlet weak var turnoverStackView: UIStackView!
    @IBOutlet weak var spreadSheetView: BISSpreadSheetView!
    @IBOutlet weak var figureLabel: UILabel!
    
    var startingFrame: CGRect?
    var dto: Any?
    
    // MARK: - Public methods:
    func configureView(model: Any?) {

        self.addShadow()
        dto = model
        if let descModel = model as? HomeDescriptionDTO {
            chartView.isHidden = true
            titleLabel.text = descModel.title
            descriptionLabel.text = descModel.description
            profitLossImageView.image = descModel.image

            if let list = descModel.turnoverList {
                for turnover in list {
                    let label = UILabel()
                    label.text = turnover
                    label.font = BISFont.bodyText.semibold
                    label.textColor = .darkGray1
                    
                    turnoverStackView.addArrangedSubview(label)
                }
            }
            
        }
        
        if let chartModel = model as? HomeChartDTO {
            titleLabel.text = chartModel.title
            if let options = HighChartManager.getHighChart(with: chartModel.charts) {
                chartView.plugins = ["bullet"]
                chartView?.options = options
            }
        }
        
        if let tableModel = model as? TableDetailsModel {
            spreadSheetView.isHidden = false
            figureLabel.isHidden = false
            titleLabel.text = tableModel.title
            spreadSheetView.tableDetails = tableModel
        }
        
    }
    
    // MARK: - Action methods:
    @IBAction func expandedButtonTapped(_ sender: Any) {
        collapseDelegate?.collapseButtonTaaped()
    }
    
    @IBAction func optionButtonTapped(_ sender: UIButton) {
        collapseDelegate?.optionButtonTapped(sender: sender)
    }
}
