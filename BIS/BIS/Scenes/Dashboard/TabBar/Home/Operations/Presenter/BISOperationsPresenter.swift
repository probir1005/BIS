//
//  BISOperationsPresenter.swift
//  BIS
//
//  Created by TSSIT on 05/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation

protocol BISOperationsDisplayLogic: class {
    func displayData(_ dataSource: [SectionViewModel])
    func displayError(_ error: String)
}

class BISOperationsPresenter: BISOperationsPresentationLogic {
    weak var viewController: BISOperationsDisplayLogic?
    
    func presentData(response: String?, error: Error?) {     
        viewController?.displayData(getDummyData())
    }
    
    private func getDummyData() -> [SectionViewModel] {
        
        let des1 = HomeDescriptionDTO(title: "Total Pipeline", image: #imageLiteral(resourceName: "lossArrow"), description: "572.3 M", turnoverList: ["Last Year: 836.0 M"])
        let des2 = HomeDescriptionDTO(title: "Target Archieve (P-V)", image: nil, description: "30%", turnoverList: ["Last Year: 68%"])
        let des3 = HomeDescriptionDTO(title: "Pipeline Predictive Conversion", image: #imageLiteral(resourceName: "lossArrow"), description: "444.8 M", turnoverList: ["Last Year Finalization: 508.9 M"])
        
        let optionList = [PopoverOptionModel(title: PopoverOptionType.annotations.rawValue, image: #imageLiteral(resourceName: "menuAnnotation"), type: PopoverOptionType.annotations), 
                          PopoverOptionModel(title: PopoverOptionType.openReport.rawValue, image: #imageLiteral(resourceName: "menuReport"), type: PopoverOptionType.openReport)]
        
        let chart1 = HomeChartDTO(title: "YTD Sales Pipeline Funnel 2019", charts: operationFunnel1, optionList: optionList)
        let chart2 = HomeChartDTO(title: "YTD Sales Pipeline Funnel 2020", charts: operationFunnel2, optionList: optionList)
        let chart3 = HomeChartDTO(title: "YOY Sales Pipeline Comparison 2020", charts: operationSplineChartJSON, optionList: optionList)
        let chart4 = HomeChartDTO(title: "P-V Sales Vs Budgeted 2020", charts: operationColumnChartJSON, optionList: optionList)
        let chart5 = HomeChartDTO(title: "2020 Prediction on 2019 Pipeline Conversion", charts: operationAllChartsJson, optionList: optionList)
        let chart6 = HomeChartDTO(title: "Week by Week Sales Pipeline Progress 2020", charts: operationSplineChartJSON2, optionList: optionList)
        
        let sections = [SectionViewModel.init(rows: [des1, des2, des3, chart1, chart2, chart3, chart4, chart5, chart6])]
        return sections
    }
}
