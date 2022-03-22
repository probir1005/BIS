//
//  AppFont.swift
//  BIS
//
//  Created by Chanchal Chauhan on 20/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

//    static let navigationTitleFont = UIFont(name: "HelveticaNeue-Medium", size: 25)
//    static let keyboardFont = UIFont(name: "HelveticaNeue-Medium", size: 20)
enum FontType: String {
    
    // Cambria Family
    case cambriaBold = "Cambria-Bold"
    
    // Open Sans Family
    case openSansBold = "OpenSans-Bold"
    case openSansMedium = "OpenSans-Medium"
    case openSansSemiBold = "OpenSans-SemiBold"
    case openSansRegular = "OpenSans-Regular"
    
    // HelveticaNeue family
    case helveticaNeueMedium = "HelveticaNeue-Medium"

    // Roboto family
    case robotoMedium = "Roboto-Medium"
    case robotoBold = "Roboto-Bold"
    case robotoRegular = "Roboto-Regular"
    
    func getFont(fontSize: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: fontSize)!
    }
}

enum BISFont: CGFloat {
    case h26 = 26
    case h20 = 20
    case h18 = 18
    case h16 = 16
    case bodyText = 12
    case smallText = 10

    var regular: UIFont {
        return UIFont(name: FontType.openSansRegular.rawValue, size: self.rawValue)!
    }
    
    var bold: UIFont {
        return UIFont(name: FontType.openSansBold.rawValue, size: self.rawValue)!
    }
    
    var semibold: UIFont {
        return UIFont(name: FontType.openSansSemiBold.rawValue, size: self.rawValue)!
    }
    
    var medium: UIFont {
        return UIFont(name: FontType.openSansMedium.rawValue, size: self.rawValue)!
    }
    
    func getFont(fontType: FontType) -> UIFont {
        return UIFont(name: fontType.rawValue, size: self.rawValue)!
    }
}
