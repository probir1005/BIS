//
//  BISHomeInteractor.swift
//  BIS
//
//  Created by TSSIT on 01/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation

protocol BISHomePresentationLogic {
    func presentData(response: String?, error: Error?)
}

class BISDashboardBaseInteractor {
    var presenter: BISHomePresentationLogic?
    
    func getChartData() {
        presenter?.presentData(response: "Empty", error: nil)
    }
}
