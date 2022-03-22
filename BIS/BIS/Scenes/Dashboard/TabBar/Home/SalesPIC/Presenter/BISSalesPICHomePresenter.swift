//
//  BISHomePresenter.swift
//  BIS
//
//  Created by TSSIT on 04/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation

protocol BISSalesPICDisplayLogic: class {
    func displayData(_ dataSource: [SectionViewModel])
    func displayError(_ error: String)
}

class BISSalesPICPresenter: BISSalesPICPresentationLogic {
    weak var viewController: BISSalesPICDisplayLogic?
    
    func presentData(response: String?, error: Error?) {     
        viewController?.displayData(getDummyData())
    }
    
    private func getDummyData() -> [SectionViewModel] {
        
        let des1 = HomeDescriptionDTO(title: "Turnover", image: #imageLiteral(resourceName: "profitArrow"), description: "41.1M", turnoverList: [])
        let des2 = HomeDescriptionDTO(title: "Sales Profit", image: nil, description: "6.3M", turnoverList: [])
        let des3 = HomeDescriptionDTO(title: "Lead/Lag(P-V)", image: #imageLiteral(resourceName: "lossArrow"), description: "62% Lag", turnoverList: ["Prediction on P-V: 199.1M"])
        
        let optionList = [PopoverOptionModel(title: PopoverOptionType.annotations.rawValue, image: #imageLiteral(resourceName: "menuAnnotation"), type: PopoverOptionType.annotations), 
                          PopoverOptionModel(title: PopoverOptionType.openReport.rawValue, image: #imageLiteral(resourceName: "menuReport"), type: PopoverOptionType.openReport)]
        
        let chart1 = HomeChartDTO(title: "Turnover VS Budget 2020", charts: salesColumnChartJSON, optionList: optionList)
        let chart2 = HomeChartDTO(title: "2020 VS 2019 Turnover", charts: salesSplineChartJSON, optionList: optionList)
        let chart3 = HomeChartDTO(title: "2020 Prediction on 2019 Pipeline Conversion", charts: saleAllChartsJson, optionList: optionList)
        let chart4 = HomeChartDTO(title: "Turnover Progress", charts: salesBulletChartJson1, optionList: optionList)
        let chart5 = HomeChartDTO(title: "Profit Progress", charts: salesBulletChartJson2, optionList: optionList)
        
        let sections = [SectionViewModel.init(rows: [des1, des2, des3, chart4, chart5, chart1, chart2, chart3])]
        return sections
    }
}
