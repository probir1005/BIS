//
//  DashBoardItems.swift
//  BIS
//
//  Created by TSSIOS on 15/07/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation

enum DashBoardItems: String {
    case management
    case sales_pic
    case sales_pipeline

    init?(type: String) {
           self.init(rawValue: type.replacingOccurrences(of: " ", with: "_").lowercased())
       }
}
