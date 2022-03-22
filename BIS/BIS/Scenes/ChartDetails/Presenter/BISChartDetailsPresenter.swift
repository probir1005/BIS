//
//  BISChartDetailsPresenter.swift
//  BIS
//
//  Created by TSSIT on 18/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation

protocol BISChartDetailsDisplayLogic: class {
    func displayData(_ dataSource: [SectionViewModel])
    func displayError(_ error: String)
}

class BISChartDetailsPresenter: BISChartDetailsPresentationLogic {
    weak var viewController: BISChartDetailsDisplayLogic?
    
    func presentData(response: HomeChartDTO?, error: Error?) {
        let chart = HomeChartDTO(title: response?.title ?? "", charts: response?.charts ?? "")
        let table = TableDetailsModel.getTableDetails(from: response?.charts ?? "")
        var rows: [Any] = [chart]
        if table != nil {
            rows.append(table!)
        }
        let sections = [SectionViewModel.init(rows: rows)]
        viewController?.displayData(sections)
    }
}
