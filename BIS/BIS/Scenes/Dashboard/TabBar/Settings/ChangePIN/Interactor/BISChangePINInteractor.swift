//
//  BISChangePINInteractor.swift
//  BIS
//
//  Created by TSSIOS on 23/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

/// Candy Module Interactor Protocol
protocol ChangePINInteractorProtocol {
    // Fetch PIN
    func fetchPIN()
    //Update PIN
    func updatePIN(pinNumber: Int)
    //Verify PIN
    func verifyPIN(pinNum: String)
}

class BISChangePINInteractor: ChangePINInteractorProtocol {

    private var pinNumber: String?
    private var savedPIN: String?
    
    var presenter: ChangePINPresenterProtocol?

    required init(withPIN PIN: String?, and savedPin: String?) {
        self.savedPIN = savedPin
        self.pinNumber = PIN
    }

    func fetchPIN() {
        self.presenter?.interactor(self, didFetch: self.pinNumber, savedPIN: self.savedPIN)
    }

    func updatePIN(pinNumber: Int) {
        self.presenter?.interactor(self, didUpdateWith: pinNumber)
    }

    func verifyPIN(pinNum: String) {
        if self.pinNumber == nil {
            self.presenter?.interactor(self, didVerifyWith: pinNum, withFetch: "", or: self.savedPIN!)
        } else {
            self.presenter?.interactor(self, didVerifyWith: pinNum, withFetch: self.pinNumber!, or: "")
        }
    }

}
