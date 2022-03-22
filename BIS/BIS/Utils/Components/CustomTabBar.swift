//
//  CustomTabBar.swift
//  BIS
//
//  Created by TSSIOS on 27/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

protocol CustomTabBarProtocol: class {

  func tabBarButtonClickAt(index: Int)
}

func createButtons(count: Int) -> [TabButton] {
    var buttons: [TabButton] = []
    for index in 0...count {
        let button = TabButton(tag: index)
        button.titleEdgeInsets = UIEdgeInsets(top: UIDevice.current.hasNotch ? 15 : 20, left: 0, bottom: 0, right: 0)
        button.titleLabel?.font = CustomTabBar.font
        button.clipsToBounds = true
        button.tintAdjustmentMode = .normal
        button.textColor = CustomTabBar.defaultColorLightMode
        button.input = CustomTabBar.Input.init(rawValue: index)!
        button.isExclusiveTouch = true
        buttons.append(button)
    }

    return buttons
}

class CustomTabBar: UIView {

    @IBInspectable var tabCount: Int = 1 {
        didSet { self.tabButtonCount = max(1, min(5, tabCount))
            self.buttons.removeAll()
            self.buttons = createButtons(count: self.tabButtonCount - 1)
            self.setup()
        }
    }

    weak var tabBarDelegate: CustomTabBarProtocol?
    static let buttonTagConstant = 5000
    static let font = BISFont.bodyText.semibold
    static let selectedColor = UIColor.dodgerBlueLight
    static let defaultColorLightMode = UIColor.darkGray2
    static let defaultColorDarkMode = UIColor.white
    var tabButtonCount: Int = 0
    var buttons: [TabButton] = []

    init() {
        super.init(frame: .zero)
        self.setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setup() {
        self.addShadow(location: .top)
        self.setSelectedIndex(index: 0, completion: nil)
        self.buttons.forEach { button in
            button.addTarget(self, action: #selector(TabButtonPressed(sender:)), for: .touchUpInside)
            self.addSubview(button)
        }
    }

    func setSelectedIndex(index: Int, completion: (() -> Void)? = nil) {
        self.buttons.forEach { (button) in
            button.isSelected = false
            if button.tag == index + CustomTabBar.buttonTagConstant {
                button.isSelected = true
            }
        }

        completion?()
    }

    @objc
    func TabButtonPressed(sender: UIButton) {
//        self.buttons.forEach { button in
//            button.isSelected = false
//            if button.tag == sender.tag {
//                button.isSelected = true
//            }
//        }

        self.setSelectedIndex(index: sender.tag - CustomTabBar.buttonTagConstant) {
            if let delegate = self.tabBarDelegate {
                delegate.tabBarButtonClickAt(index: sender.tag - CustomTabBar.buttonTagConstant)
            }
        }

    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let horizontalSpacing = CGFloat(1.0)

        let itemHeight = self.bounds.height
        let itemWidth = (self.frame.width - (CGFloat(tabButtonCount - 1) * horizontalSpacing)) / CGFloat(tabButtonCount)

        let size = CGSize(width: itemWidth, height: itemHeight)

        for count in 0...(tabButtonCount - 1) {
            let xPos = itemWidth * CGFloat(count)
            let yPos = CGFloat(0.0)

            self.buttons[count].frame.size = size
            self.buttons[count].frame.origin = CGPoint(x: xPos, y: yPos)
        }
    }
}

extension CustomTabBar {

}

class TabButton: UIButton {

    private let textOverlay = UIView()
    private let keyboardImageView = UIImageView(image: UIImage())
    var buttonCount: Int = 0

    var textColor: UIColor? {
        get { return self.textOverlay.backgroundColor }
        set { self.textOverlay.backgroundColor = newValue }
    }

    var input: CustomTabBar.Input = .home {
        didSet {
            self.keyboardImageView.image = self.input.defaultImage
            self.setTitle(self.input.text, for: .normal)
        }
    }

    override var isSelected: Bool {
        get { return super.isSelected }
        set {
            self.textColor = newValue ? CustomTabBar.selectedColor : CustomTabBar.defaultColorLightMode
            self.keyboardImageView.tintColor = newValue ? CustomTabBar.selectedColor : CustomTabBar.defaultColorLightMode
            self.keyboardImageView.image = newValue ? CustomTabBar.Input(rawValue: self.tag - CustomTabBar.buttonTagConstant)?.selectedImage : CustomTabBar.Input(rawValue: self.tag - CustomTabBar.buttonTagConstant)?.defaultImage
            super.isSelected = newValue
        }
    }

    init(tag: Int) {
        super.init(frame: .zero)
        self.tag = tag + CustomTabBar.buttonTagConstant
        self.keyboardImageView.contentMode = .top
        self.keyboardImageView.tintColor = CustomTabBar.defaultColorLightMode
        self.addSubview(self.keyboardImageView)

        self.textOverlay.isUserInteractionEnabled = false
        self.textOverlay.mask = self.titleLabel
        self.addSubview(self.textOverlay)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.textOverlay.frame = self.bounds
        let imageBounds = CGRect(origin: CGPoint(x: self.bounds.size.width/2 - 20, y: self.bounds.origin.y + (UIView.hasSafeArea ? 20 : 15)), size: CGSize(width: 40, height: 40))
        self.keyboardImageView.frame = imageBounds
    }

}

extension CustomTabBar {

    enum Input: Int {
        case home = 0
        case favourites
        case alerts
        case settings
        case exception

        var defaultImage: UIImage? {
            switch self {
            case .home: return #imageLiteral(resourceName: "home")
            case .favourites: return #imageLiteral(resourceName: "favourite")
            case .alerts: return #imageLiteral(resourceName: "alert")
            case .settings: return #imageLiteral(resourceName: "settings")
            default: return nil
            }
        }

        var selectedImage: UIImage? {
            switch self {
            case .home: return #imageLiteral(resourceName: "homeSelected")
            case .favourites: return #imageLiteral(resourceName: "favouriteSelected")
            case .alerts: return #imageLiteral(resourceName: "alertSelected")
            case .settings: return #imageLiteral(resourceName: "settingsSelected")
            default: return nil
            }
        }

        var text: String {
            switch self {
            case .home: return "Home"
            case .favourites: return "Favourites"
            case .alerts: return "Alerts"
            case .settings: return "Settings"
            default: return "*****"
            }
        }
    }

}
