//
//  BISVerifyOTPPresenter.swift
//  BIS
//
//  Created by TSSIOS on 26/08/20.
//  Copyright © 2020 TSS. All rights reserved.
//

import UIKit

protocol VerifyOTPPresenterProtocol: class {
    /// The Interactor will inform the Presenter a successful fetch.
    func interactor(_ interactor: VerifyOTPInteractorProtocol, didVerify object: UserDTO)
    /// The Interactor will inform the Presenter a failed fetch.
    func interactor(_ interactor: VerifyOTPInteractorProtocol, didFailWith error: Error)
    /// The Interactor will inform the Presenter to update values.
    func interactor(_ interactor: VerifyOTPInteractorProtocol, didUpdateResendOTPWith object: OtpDTO)
    ///
    func interactor(_ interactor: VerifyOTPInteractorProtocol, didUpdateResendOTPWithError error: Error)
}

class BISVerifyOTPPresenter {
    weak var view: VerifyOTPVCProtocol?
    var interactor: VerifyOTPInteractorProtocol?
}

// MARK: - extending Presenter to implement it's protocol
extension BISVerifyOTPPresenter: VerifyOTPPresenterProtocol {
    
    func interactor(_ interactor: VerifyOTPInteractorProtocol, didUpdateResendOTPWithError error: Error) {
        self.view?.setResendOTPViewWith(errorMessage: error.localizedDescription)
    }

    func interactor(_ interactor: VerifyOTPInteractorProtocol, didUpdateResendOTPWith object: OtpDTO) {
        self.view?.setResendOTPView(dto: object)
    }

    func interactor(_ interactor: VerifyOTPInteractorProtocol, didVerify object: UserDTO) {
        DispatchQueue.main.async {
            self.view?.confirmVerification()
        }
    }

    func interactor(_ interactor: VerifyOTPInteractorProtocol, didFailWith error: Error) {
        self.view?.set(errorMessage: error.localizedDescription)
    }

}
