//
//  TabCollectionCell.swift
//  BIS
//
//  Created by TSSIOS on 03/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

class TabCollectionCell: UICollectionViewCell {

    var tabItemButtonPressedBlock: (() -> Void)?
    var option: CustomPageOption = CustomPageOption() {
        didSet {
            currentBarViewHeightConstraint.constant = option.currentBarHeight
        }
    }
    var item: String = "" {
        didSet {
            itemLabel.text = item
            itemLabel.invalidateIntrinsicContentSize()
            invalidateIntrinsicContentSize()
        }
    }
    var isCurrent: Bool = false {
        didSet {
            currentBarView.isHidden = !isCurrent
            if isCurrent {
                highlightTitle()
            } else {
                unHighlightTitle()
            }
            currentBarView.backgroundColor = option.currentColor
            layoutIfNeeded()
        }
    }

    @IBOutlet fileprivate weak var itemLabel: UILabel!
    @IBOutlet fileprivate weak var currentBarView: UIView!
    @IBOutlet fileprivate weak var currentBarViewHeightConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()

        currentBarView.isHidden = true
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        if item.count == 0 {
            return CGSize.zero
        }

        return intrinsicContentSize
    }

    class func cellIdentifier() -> String {
        return "TabCollectionCell"
    }
}

// MARK: - View

extension TabCollectionCell {
    override var intrinsicContentSize: CGSize {
        let width: CGFloat
        if let tabWidth = option.tabWidth, tabWidth > 0.0 {
            width = tabWidth
        } else {
            width = itemLabel.intrinsicContentSize.width + option.tabMargin * 2
        }

        let size = CGSize(width: width, height: option.tabHeight)
        return size
    }

    func hideCurrentBarView() {
        currentBarView.isHidden = true
    }

    func showCurrentBarView() {
        currentBarView.isHidden = false
    }

    func highlightTitle() {
        itemLabel.textColor = option.currentColor
        itemLabel.font = FontType.robotoBold.getFont(fontSize: option.fontSize)
        //UIFont.boldSystemFont(ofSize: option.fontSize)
    }

    func unHighlightTitle() {
        itemLabel.textColor = option.defaultColor
        itemLabel.font = FontType.robotoMedium.getFont(fontSize: option.fontSize)
        //UIFont.systemFont(ofSize: option.fontSize)
    }
}

// MARK: - IBAction

extension TabCollectionCell {
    @IBAction fileprivate func tabItemTouchUpInside(_ button: UIButton) {
        tabItemButtonPressedBlock?()
    }
}
