//
//  BISChangePINPresenter.swift
//  BIS
//
//  Created by TSSIOS on 23/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

protocol ChangePINPresenterProtocol: class {
    /// The Interactor will inform the Presenter a successful fetch.
    func interactor(_ interactor: ChangePINInteractorProtocol, didFetch object: String?, savedPIN: String?)
    /// The Interactor will inform the Presenter a failed fetch.
    func interactor(_ interactor: ChangePINInteractorProtocol, didFailWith error: Error)
    /// The Interactor will inform the Presenter to update values.
    func interactor(_ interactor: ChangePINInteractorProtocol, didUpdateWith object: Int)
    func interactor(_ interactor: ChangePINInteractorProtocol, didVerifyWith object: String, withFetch pin: String, or savedPin: String)
}

class BISChangePINPresenter {
    weak var view: ChangePINVCProtocol?
    var interactor: ChangePINInteractorProtocol?
}

// MARK: - extending Presenter to implement it's protocol
extension BISChangePINPresenter: ChangePINPresenterProtocol {
    func interactor(_ interactor: ChangePINInteractorProtocol, didFetch object: String?, savedPIN: String?) {
        if object == nil && savedPIN != nil && !savedPIN!.isEmpty {
            self.view?.setInitialView(savedPIN: savedPIN!)
        } else if object == nil && savedPIN == nil {
            self.view?.setNewPINView()
        } else if object != nil && object!.isEmpty {
            self.view?.set(errorMessage: "Second PIN was different than the first one. Please try this again.")
        } else {
            self.view?.set(confirmPIN: object!)
        }
    }

    func interactor(_ interactor: ChangePINInteractorProtocol, didFailWith error: Error) {
        //
    }

    func interactor(_ interactor: ChangePINInteractorProtocol, didUpdateWith object: Int) {
        self.view?.set(pinNumber: object)
    }

    func interactor(_ interactor: ChangePINInteractorProtocol, didVerifyWith object: String, withFetch pin: String, or savedPin: String) {
        if savedPin == object {
            self.view?.pinVerified()
        } else if object == pin {
            self.view?.pinConfirmed(pin: pin)
        } else if !savedPin.isEmpty && savedPin != object {
            self.view?.setVerifyFail(errorMessage: "Please enter correct PIN.")
        } else {
            self.view?.pinConfirmedFailed()
//            self.view?.set(errorMessage: "Second PIN was different than the first one. Please try this again.")
        }
    }

}
