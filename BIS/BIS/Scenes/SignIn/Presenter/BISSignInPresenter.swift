//
//  BISSignInPresenter.swift
//  BIS
//
//  Created by TSSIOS on 30/07/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

protocol SignInPresenterProtocol: class {
    /// The Interactor will inform the Presenter a successful fetch.
    func interactor(_ interactor: SignInInteractorProtocol, didFetch object: OtpDTO)
    /// The Interactor will inform the Presenter a failed fetch.
    func interactor(_ interactor: SignInInteractorProtocol, didFailWith error: Error)
    /// The Interactor will inform the Presenter to update values.
    func interactor(_ interactor: SignInInteractorProtocol, didUpdateEyeWith object: Bool)
    ///
    func interactor(_ interactor: SignInInteractorProtocol, didUpdateCheckBoxWith object: Bool)
}

class BISSignInPresenter {
    weak var view: SignInVCProtocol?
    var interactor: SignInInteractorProtocol?
}

// MARK: - extending Presenter to implement it's protocol
extension BISSignInPresenter: SignInPresenterProtocol {
    func interactor(_ interactor: SignInInteractorProtocol, didUpdateEyeWith object: Bool) {
        self.view?.setEyeView(selected: object)
    }
    
    func interactor(_ interactor: SignInInteractorProtocol, didUpdateCheckBoxWith object: Bool) {
        self.view?.setCheckBoxView(selected: object)
    }
    
    func interactor(_ interactor: SignInInteractorProtocol, didFetch object: OtpDTO) {
        self.view?.confirmSignIn(dto: object)
    }

    func interactor(_ interactor: SignInInteractorProtocol, didFailWith error: Error) {
        self.view?.set(errorMessage: error.localizedDescription)
    }

}
