//
//  BISPINVerifyInteractor.swift
//  BIS
//
//  Created by TSSIOS on 14/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

/// Candy Module Interactor Protocol
protocol PINVerifyInteractorProtocol {
    // Fetch PIN
    func fetchPIN()
    //Update PIN
    func updatePIN(pinNumber: Int)
    //Verify PIN
    func verifyPIN(pinNum: String)
}

class BISPINVerifyInteractor: PINVerifyInteractorProtocol {

    private var pinNumber: String!
    private var appKeyChain = KeyChainService()

    var presenter: PINVerifyPresenterProtocol?

    required init() {
        self.pinNumber = ""
        if let pin = appKeyChain.get(.appLockPIN) {
            self.pinNumber = pin
        } 
    }

    func fetchPIN() {
        self.presenter?.interactor(self, didFetch: self.pinNumber)
    }

    func updatePIN(pinNumber: Int) {
        self.presenter?.interactor(self, didUpdateWith: pinNumber)
    }

    func verifyPIN(pinNum: String) {
        self.presenter?.interactor(self, didVerifyWith: pinNum, withFetch: self.pinNumber)
    }

}
