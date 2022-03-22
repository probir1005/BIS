//
//  BISSalesPICHomeInteractor.swift
//  BIS
//
//  Created by TSSIT on 04/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation

protocol BISSalesPICPresentationLogic {
    func presentData(response: String?, error: Error?)
}

class BISSalesPICInrterator: BISSalesPICBusinessLogic {
    var presenter: BISSalesPICPresentationLogic?
    
    func getChartData() {
        presenter?.presentData(response: "", error: nil)
    }
}
