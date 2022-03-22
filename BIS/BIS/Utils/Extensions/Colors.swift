//
//  Colors.swift
//  CleanSwiftPattern
//
//  Created by Chanchal Chauhan on 28/04/20.
//  Copyright © 2020 Chanchal Chauhan. All rights reserved.
//

import Foundation
import UIKit

@objc extension UIColor {
    
    // MARK: Shades of Blue
    static let astronautBlue            = #colorLiteral(red: 0.1333333333, green: 0.2, blue: 0.4117647059, alpha: 1)  // #223369
    static let dodgerBlueLight          = #colorLiteral(red: 0.1529411765, green: 0.8039215686, blue: 1, alpha: 1)  // #27CDFF  
    static let dodgerBlueDark           = #colorLiteral(red: 0, green: 0.7098039216, blue: 0.9254901961, alpha: 1)  // #00B5EC  
    
    // MARK: Shades of Green
    static let seaGreen                 = #colorLiteral(red: 0.2705882489681244, green: 0.7058823704719543, blue: 0.2823529541492462, alpha: 1.0)  // #45B448   

    // MARK: Shades of Yellow
    static let sunglow                  = #colorLiteral(red: 1.0, green: 0.8196078538894653, blue: 0.2549019753932953, alpha: 1.0)  // #FFD141  
    
    // MARK: Shades of Orange
    static let orangePeel               = #colorLiteral(red: 1.0, green: 0.5960784554481506, blue: 0.0, alpha: 1.0)  // #FF9800  
    
    // MARK: Shades of Red
    static let scarlet                  = #colorLiteral(red: 0.9019607901573181, green: 0.16470588743686676, blue: 0.062745101749897, alpha: 1.0)  // #E62A10   
    
    // MARK: Shades of Gray
    static let lightGray                = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)  // #FAFAFA
    static let lightGray1               = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)  // #E6E6E6
    static let lightGray2               = #colorLiteral(red: 0.7843137255, green: 0.7843137255, blue: 0.7843137255, alpha: 1)  // #C8C8C8
    static let lightGray3               = #colorLiteral(red: 0.5882352941, green: 0.5882352941, blue: 0.5882352941, alpha: 1)  // #969696
    static let darkGray1                = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)  // #707070
    static let darkGray2                = #colorLiteral(red: 0.2980392157, green: 0.2980392157, blue: 0.3019607843, alpha: 1)  // #4C4C4D
    static let darkGray3                = #colorLiteral(red: 0.5751589038, green: 0.5758741327, blue: 0.5781298545, alpha: 1)  // #707070
    static let textGray                 = #colorLiteral(red: 0.2117647059, green: 0.2117647059, blue: 0.2117647059, alpha: 1)  // #363636
    
    // MARK: Colors with aplha < 1
    static let blackO10                 = #colorLiteral(red: 0.3705607355, green: 0.3707022071, blue: 0.3747656047, alpha: 1)  //#000000 alpha 0.1
    static let skyBlueO90               = #colorLiteral(red: 0, green: 0.6901960784, blue: 0.9058823529, alpha: 0.9)  //#00B0E7 alpha 0.9
    static let shadow                   = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.29)  //#000000 alpha 0.29
    static let shadowBorder             = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.07345070423)  //#000000 alpha 0.07
}
