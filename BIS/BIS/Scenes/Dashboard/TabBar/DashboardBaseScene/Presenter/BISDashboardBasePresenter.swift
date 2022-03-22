//
//  BISHomePresenter.swift
//  BIS
//
//  Created by TSSIT on 01/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation

enum DashboardType {
    case management
    case sales
    case operation
}

protocol BISHomeDisplayLogic: class {
    
    func displayData(_ dataSource: [SectionViewModel])
    func displayError(_ error: String)
    
}

class BISDashboardBasePresenter: BISHomePresentationLogic {
    weak var viewController: BISHomeDisplayLogic?
    
    func presentData(response: String?, error: Error?) {     
        viewController?.displayData(getDummyData(DashboardType.management))
    }
    
    private func getDummyData(_ dashboardType: DashboardType) -> [SectionViewModel] {
        
        switch dashboardType {
        case .management:
            let des1 = HomeDescriptionDTO(title: "Turnover(2019)", image: #imageLiteral(resourceName: "profitArrow"), description: "500M", turnoverList: ["20% Invoiced", "2019 vs 2018 : 28%", "80% of Target"])
            let des2 = HomeDescriptionDTO(title: "Sales Profit(2019)", image: nil, description: "50M", turnoverList: ["15% on Invoice", "2019 vs 2018 : 15%", "50% of Target"])
            let des3 = HomeDescriptionDTO(title: "GPM(2019)", image: #imageLiteral(resourceName: "lossArrow"), description: "10%", turnoverList: ["2018 GPM : 9%"])
            let des4 = HomeDescriptionDTO(title: "Lead/Lag", image: nil, description: "20%  Lead", turnoverList: [])
            
            let chart1 = HomeChartDTO(title: "Sales Profit 2019 vs 2018", charts: managementSplineChartJSON)
            let chart2 = HomeChartDTO(title: "Performance 2019", charts: managementPerformanceChart)
            let chart3 = HomeChartDTO(title: "Budget vs Actual 2019", charts: managementColumnChartJSON)
            let chart4 = HomeChartDTO(title: "Sales Pipeline 2019", charts: managementFunnelChartJson)
            let chart5 = HomeChartDTO(title: "YTD Sales Pipeline Funnel 2020", charts: managementPieChartJSON)
            let chart6 = HomeChartDTO(title: "YTD Sales Pipeline Funnel 2020", charts: managementAreaChartJson)

            let sections = [SectionViewModel.init(rows: [des1, des2, des3, des4, chart1, chart2, chart3, chart4, chart5, chart6])]
            return sections
        default:
            let sections = [SectionViewModel.init(rows: [])]
            return sections
        }
        
    }
}
