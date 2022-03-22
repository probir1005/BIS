//
//  BISPINRegisterInteractor.swift
//  BIS
//
//  Created by TSSIOS on 20/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

/// Candy Module Interactor Protocol
protocol PINRegisterInteractorProtocol {
    // Fetch PIN
    func fetchPIN()
    //Update PIN
    func updatePIN(pinNumber: Int)
}

class BISPINRegisterInteractor: PINRegisterInteractorProtocol {

    private let pinNumber: String?

    var presenter: PINRegisterPresenterProtocol?

    required init(withPIN PIN: String?) {
        self.pinNumber = PIN
    }

    func fetchPIN() {
        self.presenter?.interactor(self, didFetch: self.pinNumber)
    }

    func updatePIN(pinNumber: Int) {
        self.presenter?.interactor(self, didUpdateWith: pinNumber)
    }

}
