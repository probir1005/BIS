//
//  BISOperationsInteractor.swift
//  BIS
//
//  Created by TSSIT on 05/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation

protocol BISOperationsPresentationLogic {
    func presentData(response: String?, error: Error?)
}

class BISOperationsInteractor: BISOperationBusinessLogic {
    var presenter: BISOperationsPresentationLogic?
    
    func getChartData() {
        presenter?.presentData(response: "Empty", error: nil)
    }
}
