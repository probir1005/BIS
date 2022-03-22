//
//  BISPINRegisterPresenter.swift
//  BIS
//
//  Created by TSSIOS on 20/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

protocol PINRegisterPresenterProtocol: class {
    /// The Interactor will inform the Presenter a successful fetch.
    func interactor(_ interactor: PINRegisterInteractorProtocol, didFetch object: String?)
    /// The Interactor will inform the Presenter a failed fetch.
    func interactor(_ interactor: PINRegisterInteractorProtocol, didFailWith error: Error)
    /// The Interactor will inform the Presenter to update values.
    func interactor(_ interactor: PINRegisterInteractorProtocol, didUpdateWith object: Int)
}

class BISPINRegisterPresenter {
    weak var view: PINRegisterVCProtocol?
    var interactor: PINRegisterInteractorProtocol?
}

// MARK: - extending Presenter to implement it's protocol
extension BISPINRegisterPresenter: PINRegisterPresenterProtocol {
    func interactor(_ interactor: PINRegisterInteractorProtocol, didFetch object: String?) {
        if object == nil {
            self.view?.setInitialView()
        } else if object != nil && object!.isEmpty {
            self.view?.set(errorMessage: object!)
        } else {
            self.view?.set(confirmPIN: object!)
        }
    }

    func interactor(_ interactor: PINRegisterInteractorProtocol, didFailWith error: Error) {
        //
    }

    func interactor(_ interactor: PINRegisterInteractorProtocol, didUpdateWith object: Int) {
        self.view?.set(pinNumber: object)
       }

}
