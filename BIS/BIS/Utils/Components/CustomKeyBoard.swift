//
//  CustomKeyBoard.swift
//  BIS
//
//  Created by TSSIOS on 20/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

protocol CustomKeyBoardProtocol: class {
  func buttonClickAtNumber(index: Int)
}

class NumericKeyboard: UIView {

    weak var keyboardDelegate: CustomKeyBoardProtocol?
    static let buttonTagConstant = 1000
    static let font = BISFont.h20.semibold

    fileprivate let rightButton = KeyboardButton()
    fileprivate let leftButton = KeyboardButton()

    let buttons: [KeyboardButton] = {
        var buttons: [KeyboardButton] = []
        for count in 0...9 {
            let button = KeyboardButton()
            button.backgroundColor = .clear
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)

            button.titleLabel?.font = NumericKeyboard.font
            button.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            button.input = .numeric(number: count)
            button.isExclusiveTouch = true
            buttons.append(button)
        }

        return buttons
    }()

    init() {
        super.init(frame: .zero)
        self.setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    private func setup() {
        var keyboardButtons = [self.rightButton, self.leftButton]
        keyboardButtons.append(contentsOf: self.buttons)

        for (index, button) in keyboardButtons.enumerated() {
            button.tag = Int(button.titleLabel?.text ?? "\(100 + index)")! + NumericKeyboard.buttonTagConstant
            button.addTarget(self, action: #selector(keyBoardButtonPressed(sender:)), for: .touchUpInside)
            self.addSubview(button)
        }
//        keyboardButtons.forEach { button in
//            button.tag = Int(button.titleLabel?.text ?? "100")! + NumericKeyboard.buttonTagConstant
//            button.addTarget(self, action: #selector(keyBoardButtonPressed(sender:)), for: .touchUpInside)
//            self.addSubview(button)
//            // need to add button tap delegate
//        }
    }

    @objc
    func keyBoardButtonPressed(sender: UIButton) {
        if let delegate = keyboardDelegate {
            delegate.buttonClickAtNumber(index: sender.tag - NumericKeyboard.buttonTagConstant)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let horizontalSpacing = self.frame.height * (26.0 / 278.0)
        let verticalSpacing = self.frame.height - (56*4) + 10//self.frame.width * (46.0 / 303.0)

        let itemHeight = (self.frame.height - (3 * verticalSpacing)) / 4
        let itemWidth = (self.frame.width - (2 * horizontalSpacing)) / 3

        let hItemOffset = itemWidth + horizontalSpacing
        let vItemOffset = itemHeight + verticalSpacing

        let size = CGSize(width: itemWidth, height: itemHeight)

        for count in 0...8 {
            let xPos = (itemWidth / 2) + (CGFloat(count % 3) * hItemOffset)
            let yPos = (itemHeight / 2) + (CGFloat(count / 3) * vItemOffset)

            self.buttons[count + 1].frame.size = size
            self.buttons[count + 1].center = CGPoint(x: xPos, y: yPos)
        }

        self.buttons[0].frame.size = size
        self.buttons[0].center = CGPoint(x: (itemWidth / 2) + hItemOffset, y: itemHeight / 2 + 3 * vItemOffset)

        self.rightButton.frame.size = size
        self.rightButton.center = CGPoint(x: (itemWidth / 2) + 2 * hItemOffset, y: itemHeight / 2 + 3 * vItemOffset)

        self.leftButton.frame.size = size
        self.leftButton.center = CGPoint(x: (itemWidth / 2), y: itemHeight / 2 + 3 * vItemOffset)
    }

}

extension NumericKeyboard {

    var rightButtonHidden: Bool {
        get { return self.rightButton.isHidden }
        set { self.rightButton.isHidden = newValue }
    }

    var leftButtonHidden: Bool {
        get { return self.leftButton.isHidden }
        set { self.leftButton.isHidden = newValue }
    }

    var rightButtonInput: NumericKeyboard.Input {
        get { return self.rightButton.input }
        set { self.rightButton.input = newValue }
    }

    var leftButtonInput: NumericKeyboard.Input {
        get { return self.leftButton.input }
        set { self.leftButton.input = newValue }
    }

}

class KeyboardButton: UIButton {

    private let textOverlay = UIView()
    private let keyboardImageView = UIImageView(image: UIImage())
//    private let backgroundLayer = CALayer()

    var textColor: UIColor? {
        get { return self.textOverlay.backgroundColor }
        set { self.textOverlay.backgroundColor = newValue }
    }

    var input: NumericKeyboard.Input = .erase {
        didSet {
            self.keyboardImageView.image = self.input.image
            self.setTitle(self.input.text, for: .normal)
        }
    }

    override var isHighlighted: Bool {
        get { return super.isHighlighted }
        set {
            (self as UIButton).bounceButtonEffect()
            super.isHighlighted = newValue
        }
    }

    init() {
        super.init(frame: .zero)

        self.keyboardImageView.contentMode = .center
        //self._imageView.isUserInteractionEnabled = true
        self.keyboardImageView.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.addSubview(self.keyboardImageView)

        self.textOverlay.isUserInteractionEnabled = false
        self.textOverlay.mask = self.titleLabel
        self.addSubview(self.textOverlay)

//        self.layer.insertSublayer(self.backgroundLayer, at: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.textOverlay.frame = self.bounds
        self.keyboardImageView.frame = self.bounds
    }
}

extension NumericKeyboard {

    enum Input {
        case numeric(number: Int)
        case erase
        case help
        case forgot
        case face
        case finger

        var image: UIImage? {
            switch self {
            case .numeric: return #imageLiteral(resourceName: "keyboardButton")
            case .erase: return #imageLiteral(resourceName: "deleteKey")
            case .face: return #imageLiteral(resourceName: "iconsTouchId")
            case .help: return nil
            case .forgot: return #imageLiteral(resourceName: "forgotPwd")
            case .finger: return #imageLiteral(resourceName: "iconsPhoneTouch")
            }
        }

        var text: String {
            switch self {
            case .numeric(let num): return String(num)
            case .help: return "?"
            default: return ""
            }
        }

    }

}
