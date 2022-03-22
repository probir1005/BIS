//
//  BISSpreadSheetHeaderView.swift
//  BIS
//
//  Created by TSSIT on 23/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

class BISSpreadSheetHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var headerStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureHeader(with columns: [String], widths: [CGFloat]) {
        guard headerStackView.arrangedSubviews.count == 0 else {
            return
        }
        
        for element in columns.enumerated() {
            let columnView: BISColumnView = .fromNib()
            columnView.columnLabel.text = element.element
            columnView.frame = CGRect(x: 0, y: 0, width: widths[element.offset], height: 33.0)
            if element.offset != columns.count - 1 {
                columnView.widthAnchor.constraint(equalToConstant: widths[element.offset]).isActive = true
            }
            headerStackView.addArrangedSubview(columnView)
        }
    }
}
