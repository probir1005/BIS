//
//  SplashVC.swift
//  BIS
//
//  Created by TSSIT on 18/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

private let animationTime = 2.0

protocol SplashVCProtocol {
    var animationComplete: (() -> Void)? { get set }
}

class BISSplashVC: BaseViewController, SplashVCProtocol {
    
    var animationComplete: (() -> Void)?
    
    // MARK: - Outlets and properties:
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var appLogoImageView: UIImageView!
    
    // MARK: - View Controller life cycle methods:
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimation()
    }
    
    // MARK: - Private instance methods:
    private func startAnimation() {
        animateLogo()
        animateTitle()
        animateSubtitle()
    }
    
    private func animateLogo() {
        UIView.animate(withDuration: animationTime, animations: { 
           self.appLogoImageView.alpha = 1.0 
        })
    }
    
    private func animateTitle() {
        let titleLabel = UILabel.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: 0, height: titleView.frame.size.height)))
        titleLabel.font = FontType.cambriaBold.getFont(fontSize: 65.0)
        titleLabel.textColor = .astronautBlue
        titleLabel.text = Strings.SplashVC.business
        titleLabel.textAlignment = .center
        
        titleView.addSubview(titleLabel)
        
        UIView.animate(withDuration: animationTime, animations: { 
            titleLabel.frame = CGRect.init(origin: .zero, size: CGSize.init(width: self.titleView.frame.size.width, height: self.titleView.frame.size.height))
        })
    }
    
    private func animateSubtitle() {
        UIView.animate(withDuration: animationTime, animations: { 
            self.subtitleLabel.alpha = 1.0
        }) { _ in
            self.animationComplete?()
        }
    }
}
