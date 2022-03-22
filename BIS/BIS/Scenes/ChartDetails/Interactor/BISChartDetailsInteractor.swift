//
//  BISChartDetailsInteractor.swift
//  BIS
//
//  Created by TSSIT on 18/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation

protocol BISChartDetailsPresentationLogic {
    func presentData(response: HomeChartDTO?, error: Error?)
}

class BISChartDetailsInteractor: BISChartDetailsBusinessLogic {
    var presenter: BISChartDetailsPresentationLogic?
    
    func getChartData(fromJson chartJson: HomeChartDTO?) {
        presenter?.presentData(response: chartJson, error: nil)
    }
}
