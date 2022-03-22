//
//  BISHomePresenter.swift
//  BIS
//
//  Created by TSSIOS on 15/07/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

protocol HomePresenterProtocol: class {
    /// The Interactor will inform the Presenter a successful fetch.
    func interactor(_ interactor: HomeInteractorProtocol, didFetch object: [(viewController: UIViewController, title: String)])
}

class BISHomePresenter {
    weak var view: HomeVCProtocol?
    var interactor: HomeInteractorProtocol?
}

// MARK: - extending Presenter to implement it's protocol
extension BISHomePresenter: HomePresenterProtocol {
    func interactor(_ interactor: HomeInteractorProtocol, didFetch object: [(viewController: UIViewController, title: String)]) {
        self.view?.setUpView(withControllers: object)
    }

}
