//
//  BISHomeInteractor.swift
//  BIS
//
//  Created by TSSIOS on 15/07/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

/// Candy Module Interactor Protocol
protocol HomeInteractorProtocol {
    // Fetch PIN
    func fetchDashboardItems()
}

class BISHomeInteractor: HomeInteractorProtocol {

    var controllers: [(viewController: UIViewController, title: String)]?

    var presenter: HomePresenterProtocol?

    required init(withControllers controllers: [BISDashboardBaseVC]) {
        let dbWorker = BISVerifyOTPDBWorker(manager: DependencyInjector.get()!)
        dbWorker.fetchUser(callBack: { user in
            if user != nil {
                self.controllers = zip(controllers, user!.dashboardList).map { obj -> (viewController: UIViewController, title: String) in
                    switch DashBoardItems(type: obj.1) {
                    case .management:
                        //                    print(String(describing: obj.0.topViewController))
                        return (obj.0, "Management")
                    case .sales_pic:
                        //                    print(String(describing: obj.0.topViewController))
                        return (obj.0, "Sales PIC")
                    case .sales_pipeline:
                        //                    print(String(describing: obj.0.topViewController))
                        return (obj.0, "Sales Pipeline")
                    default:
                        return (obj.0, "Management")
                    }
                }
            } else {
                self.controllers = controllers.map { ($0, "Management") }
            }
        })
//        if let user = UserDefaultsService().getUser() {
//            self.controllers = zip(controllers, user.dashboardList).map { obj -> (viewController: UIViewController, title: String) in
//                switch DashBoardItems(type: obj.1) {
//                case .management:
////                    print(String(describing: obj.0.topViewController))
//                    return (obj.0, "Management")
//                case .sales_pic:
////                    print(String(describing: obj.0.topViewController))
//                    return (obj.0, "Sales PIC")
//                case .sales_pipeline:
////                    print(String(describing: obj.0.topViewController))
//                    return (obj.0, "Sales Pipeline")
//                default:
//                    return (obj.0, "Management")
//                }
//            }
//        } else {
//            self.controllers = controllers.map { ($0, "Management") }
//        }
    }

    func fetchDashboardItems() {
        self.presenter?.interactor(self, didFetch: self.controllers ?? [])
    }
}
