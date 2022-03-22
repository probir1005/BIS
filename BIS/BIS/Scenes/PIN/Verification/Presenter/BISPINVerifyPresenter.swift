//
//  BISPINVerifyPresenter.swift
//  BIS
//
//  Created by TSSIOS on 14/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

protocol PINVerifyPresenterProtocol: class {
    /// The Interactor will inform the Presenter a successful fetch.
    func interactor(_ interactor: PINVerifyInteractorProtocol, didFetch object: String?)
    /// The Interactor will inform the Presenter a failed fetch.
    func interactor(_ interactor: PINVerifyInteractorProtocol, didFailWith error: Error)
    /// The Interactor will inform the Presenter to update values.
    func interactor(_ interactor: PINVerifyInteractorProtocol, didUpdateWith object: Int)
    ///
    func interactor(_ interactor: PINVerifyInteractorProtocol, didVerifyWith object: String, withFetch pin: String)
}

class BISPINVerifyPresenter {
    weak var view: PINVerifyVCProtocol?
    var interactor: PINVerifyInteractorProtocol?
}

// MARK: - extending Presenter to implement it's protocol
extension BISPINVerifyPresenter: PINVerifyPresenterProtocol {
    func interactor(_ interactor: PINVerifyInteractorProtocol, didFetch object: String?) {
        if object != nil {
            self.view?.setInitialView(pin: object!)
        } else if object != nil && object!.isEmpty {
            //keychain failure
        }
    }

    func interactor(_ interactor: PINVerifyInteractorProtocol, didFailWith error: Error) {
        //
    }

    func interactor(_ interactor: PINVerifyInteractorProtocol, didUpdateWith object: Int) {
        self.view?.set(pinNumber: object)
    }

    func interactor(_ interactor: PINVerifyInteractorProtocol, didVerifyWith object: String, withFetch pin: String) {
        if object == pin {
            self.view?.pinVerified()
        } else {
            self.view?.set(errorMessage: "Please enter correct PIN.")
        }
    }
}
