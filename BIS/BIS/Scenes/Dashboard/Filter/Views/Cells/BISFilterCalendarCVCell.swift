//
//  BISFilterCalendarCVCell.swift
//  BIS
//
//  Created by TSSIOS on 04/07/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

class BISFilterCalendarCVCell: UICollectionViewCell, ReuseIdentifier, NibLoadableView {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateButton: UIButton!
    var dto: ItemFilterDTO!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(with dto: ItemFilterDTO) {
        self.dto = dto
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"

        self.dateButton.setTitle(dto.title, for: .normal)

        if let date = Date(string: dto.title, formatter: dateFormatter) {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE"
            let title = formatter.string(from: date)
            self.dateLabel.text = title
            self.dateButton.setTitle(dto.title?.components(separatedBy: "-").last?.components(separatedBy: " ").first, for: .normal)
        }
        self.dateButton.isSelected = dto.isSelected
        self.dateButton.backgroundColor = dto.isSelected ? UIColor.dodgerBlueLight : UIColor.white
        self.dateButton.setTitleColor(.dodgerBlueLight, for: .normal)
        self.dateButton.setTitleColor(.white, for: .selected)
    }
    
}
