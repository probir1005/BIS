//
//  CodeView.swift
//  BIS
//
//  Created by TSSIOS on 13/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

class CodeView: UIView {

    static let starViewTagConstant = 5000

    var view: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup {
            didLoad()
        }
    }

    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
        nibSetup {
            didLoad()
        }
    }

    convenience init() {
        self.init(frame: .zero)
    }

    func didLoad() {
      resetStarView()
    }

    public func starViewHidden(tag: Int) {
        for starView in self.view.subviews {
            if starView.tag == tag + CodeView.starViewTagConstant {
                starView.alpha = 0.1
                starView.isHidden = !starView.isHidden
                starView.fadeIn(0.2)
                break
            }
        }
    }

    public func resetStarView() {
        for starView in self.view.subviews {
            if starView.tag >= CodeView.starViewTagConstant && starView.tag <= CodeView.starViewTagConstant + 5 {
                starView.isHidden = true
            }
        }
    }
}

private extension CodeView {

    func nibSetup(completion: () -> Void) {
        backgroundColor = .clear

        view = loadNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true

        addSubview(view)
        completion()
    }
}
