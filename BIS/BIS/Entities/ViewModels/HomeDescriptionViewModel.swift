//
//  HomeRowViewModel.swift
//  BIS
//
//  Created by TSSIT on 01/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit
import Highcharts

protocol BaseDashboardDTOProtocol {
    var title: String? { get set }
    var optionList: [PopoverOptionModel] { get set }
}

struct HomeDescriptionDTO: BaseDashboardDTOProtocol {
    var title: String?
    var image: UIImage?
    var description: String?
    var turnoverList: [String]?
    var optionList: [PopoverOptionModel] = [PopoverOptionModel(title: PopoverOptionType.manageAlerts.rawValue, image: #imageLiteral(resourceName: "menuManageAlert"), type: PopoverOptionType.manageAlerts),
        PopoverOptionModel(title: PopoverOptionType.annotations.rawValue, image: #imageLiteral(resourceName: "menuAnnotation"), type: PopoverOptionType.annotations)]
}

struct HomeChartDTO: BaseDashboardDTOProtocol {
    var title: String?
    var charts: String
    var optionList: [PopoverOptionModel] = [PopoverOptionModel(title: PopoverOptionType.annotations.rawValue, image: #imageLiteral(resourceName: "menuAnnotation"), type: PopoverOptionType.annotations)]
}
