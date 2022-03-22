//
//  CustomLayerView.swift
//  BIS
//
//  Created by TSSIOS on 15/09/20.
//  Copyright © 2020 TSS. All rights reserved.
//

import UIKit

class CustomLayerView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialize() {
        self.backgroundColor = .white
        let imageview = UIImageView(frame: self.frame)
        imageview.image = UIImage(named: "bg_splash")
        imageview.contentMode = .scaleAspectFit
        self.addSubview(imageview)
    }

    func showLayer() {
        AppDelegate.getKeyWindow()?.addSubview(self)
    }

    func removeLayer() {
        if AppDelegate.getKeyWindow() != nil {
            for vw in AppDelegate.getKeyWindow()!.subviews {
                if vw is CustomLayerView {
                    vw.removeFromSuperview()
                }
            }
        }
    }

}
