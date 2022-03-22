//
//  PrimaryButtons.swift
//  BIS
//
//  Created by TSSIT on 21/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

@IBDesignable
class PrimaryButton: UIButton {
    
    let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeView()
    }
    
    private func initializeView() {
        addGradient()
        self.contentVerticalAlignment = .center
        self.setTitleColor(UIColor.white, for: .normal)
        self.titleLabel?.font = BISFont.h18.bold
        self.titleLabel?.textColor = UIColor.white
        clipsToBounds = false
    }
    
    func addGradient() {

        self.backgroundColor = nil
        self.layoutIfNeeded()
        gradientLayer.colors = [UIColor.dodgerBlueDark.cgColor,
                                UIColor.dodgerBlueLight.cgColor,
                                UIColor.dodgerBlueDark.cgColor]
        gradientLayer.locations = [0.0, 0.8, 1.0]
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = 5.0
        
        gradientLayer.shadowColor = UIColor.shadow.cgColor
        gradientLayer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        gradientLayer.shadowRadius = 5.0
        gradientLayer.shadowOpacity = 1.0
        gradientLayer.masksToBounds = false
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    override var isEnabled: Bool {
        get { return super.isEnabled }
        set {
            self.gradientLayer.colors = newValue ? [UIColor.dodgerBlueDark.cgColor,
            UIColor.dodgerBlueLight.cgColor,
            UIColor.dodgerBlueDark.cgColor] : [UIColor.lightGray2.cgColor,
            UIColor.lightGray1.cgColor,
            UIColor.lightGray2.cgColor]
            self.isUserInteractionEnabled = newValue
            super.isEnabled = newValue
        }
    }
    
}
