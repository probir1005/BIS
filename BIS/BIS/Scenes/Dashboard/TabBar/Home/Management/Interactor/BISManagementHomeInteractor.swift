//
//  BISManagementHomeInrterator.swift
//  BIS
//
//  Created by TSSIT on 04/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation

protocol BISManagementHomePresentationLogic {
    func presentData(response: String?, error: Error?)
}

class BISManagementHomeInteractor: BISManagementHomeBusinessLogic {
    var presenter: BISManagementHomePresentationLogic?
    
    func getChartData() {
        presenter?.presentData(response: "", error: nil)
    }
}
