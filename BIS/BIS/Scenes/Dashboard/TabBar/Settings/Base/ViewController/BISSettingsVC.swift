//
//  BISSettingsVC.swift
//  BIS
//
//  Created by TSSIOS on 29/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import LocalAuthentication
import UIKit

protocol BISSettingsVCProtocol: class {
    var onChangePIN: (() -> Void)? { get set }
    var onPrivacyPolicy: ((_ title: String) -> Void)? { get set }
    var onAboutUS: (() -> Void)? { get set }
    var onFinish: (() -> Void)? { get set }
}

class BISSettingsVC: BaseViewController, BISSettingsVCProtocol {

    var onPrivacyPolicy: ((_ title: String) -> Void)?
    var onAboutUS: (() -> Void)?
    var onChangePIN: (() -> Void)?
    var onFinish: (() -> Void)?
    let bioAuth = BiometricAuthentication()

    @IBOutlet weak var settingsCollectionView: UICollectionView!

    private var spacing: CGFloat = 0.0
    private let cellHeight: CGFloat = 50.0
    private let headerHeight: CGFloat = 40.0
    var settingsDTOArray = [SettingsDTO]()

    override func viewDidLoad() {
        self.screenTitle = "Settings"
        super.viewDidLoad()
        self.leftBarButtonAction(image: #imageLiteral(resourceName: "hamburger-menu")) { _ in
            self.drawer()?.openMenu()
        }
        self.loadData()
        self.initializeCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customTabBarController()?.hideTabBar(isHide: false)
        settingsCollectionView?.collectionViewLayout.invalidateLayout()
        settingsCollectionView?.layoutSubviews()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if !CustomNavigationController.appDelegate.landscape {
            spacing = 0
        } else {
            spacing = 35
        }
        settingsCollectionView?.collectionViewLayout.invalidateLayout()
        settingsCollectionView?.layoutIfNeeded()
    }

    private func loadData() {
        self.settingsDTOArray = settingsData.map {
            SettingsDTO(json: $0)
        }
    }

    private func initializeCollectionView() {
            settingsCollectionView.register(cell: BISSettingsCVCell.self)
            settingsCollectionView.register(nib: "BISSettingsHeaderView", forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "BISSettingsHeaderView")

            let layout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
            layout.minimumLineSpacing = spacing
            layout.minimumInteritemSpacing = spacing
            self.settingsCollectionView?.collectionViewLayout = layout
        }
    
    func authenticate(item: SettingsItemDTO) {
            self.bioAuth.authenticateUser(completion: { success, error in
                var biometricCode: Int?
                    biometricCode = LAError.Code.biometryLockout.rawValue
                if error != nil {
                    if error?.codeFromError == biometricCode {
                        UIAlertController.alert("", message: error?.localizedDescription).show()
                    } else {
    //                    UIAlertController.alert("", message: "Something went wrong. Please try again later.").show()
                    }
                } else if success {
                    UserDefaults.setVal(value: item.status, forKey: UserDefaultsKey.enableBio)
                    self.settingsDTOArray[1].items?[1] = item
                    self.settingsCollectionView.reloadData()
                }
            })
        }
}

extension BISSettingsVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return settingsDTOArray.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - (spacing * 2), height: headerHeight)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        guard let items = settingsDTOArray[section].items else {
            return 0
        }
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "BISSettingsHeaderView", for: indexPath) as! BISSettingsHeaderView
         let headerItem = settingsDTOArray[indexPath.section]
        headerView.autoresizingMask = .flexibleWidth
        headerView.translatesAutoresizingMaskIntoConstraints = true
        headerView.configureView(with: headerItem)
        return headerView
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let settingsCell: BISSettingsCVCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        guard let item = settingsDTOArray[indexPath.section].items?[indexPath.item] else {
            return UICollectionViewCell()
        }
        settingsCell.configureCell(with: item, isLast: ((settingsDTOArray[indexPath.section].items?.count ?? 0) - 1 == indexPath.item), parentController: self)
        return settingsCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - (spacing * 2), height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 1:
                self.onAboutUS?()
            case 2:
                self.onPrivacyPolicy?("Privacy Policy")
            default: break
            }
        case 1 :
            if indexPath.item == 0 {
                self.onChangePIN?()
            }
        default:
            break
        }
    }
}

extension BISSettingsVC {

    var settingsData: [[String: Any]] {
        return [
            ["heading": "General Settings", "items": [["settingTitle": "Alerts", "status": UserDefaultsService().getBool(key: .notification), "value": nil], ["settingTitle": "About Us", "status": nil, "value": nil], ["settingTitle": "Privacy Policy", "status": nil, "value": nil], ["settingTitle": "Assistive Full Screen mode", "status": UserDefaultsService().getBool(key: .enableAssistiveZoom), "value": nil]]],
            ["heading": "Security Settings", "items": [["settingTitle": "Change PIN", "status": nil, "value": nil], ["settingTitle": bioAuth.biometricType == .faceID ? "Enable Face ID" : "Enable Touch ID", "status": UserDefaultsService().getBool(key: .enableBio), "value": nil]]]
        ]
    }

}
