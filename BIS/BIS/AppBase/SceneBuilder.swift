//
//  SceneBuilder.swift
//  BIS
//
//  Created by TSSIOS on 21/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

// MARK: - Interfaces
//
//public protocol ViewPresenterInterface: class {
//
//}
//
//public protocol ViewInteractorInterface: class {
//
//}
//
//public protocol PresenterViewInterface: class {
//
//}
//
//public protocol InteractorPresenterInterface: class {
//
//}
//
// MARK: - VIP
//
//public protocol ViewInterface: ViewInteractorInterface & ViewPresenterInterface {
//    associatedtype PresenterView
//    associatedtype InteractorView
//
//    var presenter: PresenterView! { get set }
//    var interactor: InteractorView! { get set }
//}
//
//public protocol InteractorInterface: InteractorPresenterInterface {
//    associatedtype PresenterInteractor
//
//    var presenter: PresenterInteractor! { get set }
//}
//
//public protocol PresenterInterface: PresenterViewInterface {
//    associatedtype ViewPresenter
//
//    var view: ViewPresenter! { get set }
//}
//
// MARK: - module
//
//public protocol ModuleInterface {
//
//    associatedtype View where View: ViewInterface
//    associatedtype Presenter where Presenter: PresenterInterface
//    associatedtype Interactor where Interactor: InteractorInterface
//
//    func assemble(view: View, presenter: Presenter, interactor: Interactor)
//}
//
//public extension ModuleInterface {
//
//func assemble(view: View, presenter: Presenter, interactor: Interactor) {
//    view.presenter = (presenter as! Self.View.PresenterView)
//    view.interactor = (interactor as! Self.View.InteractorView)
//    presenter.view = (view as! Self.Presenter.ViewPresenter)
//    interactor.presenter = (presenter as! Self.Interactor.PresenterInteractor)
//}

class SceneBuilder {

    class func buildModule<V, P, I>(arroundView view: V, withPresenter presenter: P, withInteractor interactor: I) {

        // MARK: Initialise components.
        let presenter = P.self
        let interactor = I.self
        let viewController = V.self

        print(String(describing: presenter))
        print(String(describing: interactor))
        print(String(describing: viewController))
        // MARK: link VIP components.
//        viewController.presenter = presenter
//        view.interactor = interactor
//        presenter.view = view
//        interactor.presenter = presenter

        //Will fix Later when DI applied
    }
}
