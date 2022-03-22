//
//  BISSettingsCVCell.swift
//  BIS
//
//  Created by TSSIOS on 11/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import LocalAuthentication
import UIKit

class BISSettingsCVCell: UICollectionViewCell, ReuseIdentifier, NibLoadableView {

    @IBOutlet weak var disableView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var settingsImageView: UIImageView!
    @IBOutlet weak var separatorLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var statusSwitch: UISwitch!
    var dto: SettingsItemDTO!
    var controller: UIViewController?
    let bioAuth = BiometricAuthentication()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(with dto: SettingsItemDTO, isLast: Bool, parentController: UIViewController) {
        self.dto = dto
        self.controller = parentController
        self.titleLabel.text = dto.title
        self.settingsImageView.image = UIImage(imageLiteralResourceName: dto.title!.replacingOccurrences(of: " ", with: "_").lowercased())
        self.statusSwitch.isHidden = dto.status == nil
        self.arrowImageView.isHidden = dto.status != nil
        self.separatorLabel.isHidden = isLast
        self.statusSwitch.isOn = dto.status ?? false
        if dto.title == "Enable Touch ID" || dto.title == "Enable Face ID" {
            self.disableView.isHidden = self.bioAuth.canEvaluatePolicy()
        } else {
            self.disableView.isHidden = true
        }
    }

    @IBAction func settingsSwitchAction(_ sender: UISwitch) {
        self.dto.status = sender.isOn
        switch self.dto.title {
        case "Alerts":
            UserDefaults.setVal(value: self.dto.status, forKey: UserDefaultsKey.notification)
        case "Assistive Full Screen mode":
            UserDefaults.setVal(value: self.dto.status, forKey: UserDefaultsKey.enableAssistiveZoom)
        case "Enable PIN":
            UserDefaults.setVal(value: self.dto.status, forKey: UserDefaultsKey.enablePIN)
        case "Enable Touch ID", "Enable Face ID":
            if let parentController = self.controller as? BISSettingsVC {
                parentController.authenticate(item: self.dto)
            }
//            UserDefaults.setVal(value: self.dto.status, forKey: UserDefaultsKey.enableBio)
        default:
            break
        }
    }
}
