//
//  Utils.swift
//  BIS
//
//  Created by TSSIT on 09/07/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation

class Utils {
    
    static func getSalesPipelineData() -> [Any] {
        
        let chart1 = HomeChartDTO(title: "P-V Sales Vs Budgeted 2020", charts: salesPipelineReportChart1)
        let chart2 = HomeChartDTO(title: "YOY Sales Pipeline Comparison 2020", charts: salesPipelineReportChart2)
        let table1 = TableDetailsModel.getTableDetails(from: salesPipelineReportTable1) ?? TableDetailsModel()
        let table2 = TableDetailsModel.getTableDetails(from: salesPipelineReportTable2) ?? TableDetailsModel()
        
        return [chart1, chart2, table1, table2]
    }
    
    static func getSalesPICData() -> [Any] {
        
        let chart1 = HomeChartDTO(title: "P-V Sales Vs Budgeted 2020", charts: salesPICReportChart1)
        let chart2 = HomeChartDTO(title: "YOY Sales Pipeline Comparison 2020", charts: salesPICReportChart2)
        let table1 = TableDetailsModel.getTableDetails(from: salesPICReportTable1) ?? TableDetailsModel()
        
        return [chart1, chart2, table1]
    }
}
