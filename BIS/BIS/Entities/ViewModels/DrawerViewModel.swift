//
//  DrawerViewModel.swift
//  BIS
//
//  Created by TSSIT on 27/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

enum DrawerModelType {
    case home
    case report
    case favourites
    case alerts
    case settings
    case feedback
    case logout
}

class DrawerViewModel {
    var title: String?
    var logoImage: UIImage?
    var logoSeletedImage: UIImage?
    var arrowImage: UIImage? = #imageLiteral(resourceName: "drawerArrowForward")
    var isExpandable = false
    var isExpanded = false
    var isSelected = false
    var subViews: [Any]?
    var modelType: DrawerModelType?
    var modelIndex = 0
    
    init(title: String?, logoImage: UIImage?, logoSeletedImage: UIImage?, arrowImage: UIImage? = #imageLiteral(resourceName: "drawerArrowForward"), isExpendable: Bool = false, isExpended: Bool = false, isSelected: Bool = false, subViews: [Any]? = nil, modelType: DrawerModelType?, modelIndex: Int) {
        self.title = title
        self.logoImage = logoImage
        self.logoSeletedImage = logoSeletedImage
        self.arrowImage = arrowImage
        self.isExpandable = isExpendable
        self.isExpanded = isExpended
        self.isSelected = isSelected
        self.subViews = subViews
        self.modelType = modelType
        self.modelIndex = modelIndex
    }
    
    static func getDrawerViewModel() -> [DrawerViewModel] {
        var drawerList = [DrawerViewModel]()
        var selectedIndex: Int = 0
        if let sidePanel = UIApplication.shared.topMostViewController() as? CustomSidePanel {
            if let controller = (sidePanel.centerViewController)?.viewControllers.first as? BISTabBarVC {
                selectedIndex = controller.selectedTabIndex
            }
        }

        // Home
        let home = DrawerViewModel(title: "Home", logoImage: #imageLiteral(resourceName: "drawerHome"), logoSeletedImage: #imageLiteral(resourceName: "drawerHomeSelected"), isSelected: selectedIndex == 0 ? true : false, modelType: .home, modelIndex: 0)
        
        // Report
//        guard let user = UserDefaultsService().getUser() else {
//            return []
//        }
        var user: UserDTO?
        let dbWorker = BISVerifyOTPDBWorker(manager: DependencyInjector.get()!)
        dbWorker.fetchUser(callBack: { userObj in
            if userObj != nil {
                user = userObj
            }
        })

        let reportList =  user?.reportList.map { obj -> DrawerViewModel in
            switch obj {
            case "Management":
                return DrawerViewModel(title: "Management", logoImage: #imageLiteral(resourceName: "drawerManagement"), logoSeletedImage: #imageLiteral(resourceName: "drawerManagementSelected"), modelType: .report, modelIndex: 0)
            case "Sales PIC":
                return DrawerViewModel(title: "Sales PIC", logoImage: #imageLiteral(resourceName: "drawerSales"), logoSeletedImage: #imageLiteral(resourceName: "drawerSalesSelected"), modelType: .report, modelIndex: 1)
            case "Sales Pipeline":
                return DrawerViewModel(title: "Sales Pipeline", logoImage: #imageLiteral(resourceName: "drawerOperations"), logoSeletedImage: #imageLiteral(resourceName: "drawerOperationsSelected"), modelType: .report, modelIndex: 2)
            default:
                 return DrawerViewModel(title: "Management", logoImage: #imageLiteral(resourceName: "drawerManagement"), logoSeletedImage: #imageLiteral(resourceName: "drawerManagementSelected"), modelType: .report, modelIndex: 0)
            }
        }
        
        let report = DrawerViewModel(title: "Reports", logoImage: #imageLiteral(resourceName: "drawerReport"), logoSeletedImage: #imageLiteral(resourceName: "drawerReportSelected"), arrowImage: #imageLiteral(resourceName: "drawerArrowForward"), isExpendable: true, isSelected: false, subViews: reportList, modelType: .report, modelIndex: 1)

        // Favourites
        let fav = DrawerViewModel(title: "Favourites", logoImage: #imageLiteral(resourceName: "drawerFavourites"), logoSeletedImage: #imageLiteral(resourceName: "drawerFavouritesSelected"), isSelected: selectedIndex == 1 ? true : false, modelType: .favourites, modelIndex: 2)
        
        // Alerts
        let alerts = DrawerViewModel(title: "Alerts", logoImage: #imageLiteral(resourceName: "drawerAlerts"), logoSeletedImage: #imageLiteral(resourceName: "drawerAlertsSelected"), isSelected: selectedIndex == 2 ? true : false, modelType: .alerts, modelIndex: 3)
        
        // Settings
        let settings = DrawerViewModel(title: "Settings", logoImage: #imageLiteral(resourceName: "drawerSettings"), logoSeletedImage: #imageLiteral(resourceName: "drawerSettingsSelected"), isSelected: selectedIndex == 3 ? true : false, modelType: .settings, modelIndex: 4)
        
        // Feedback
        let feedback = DrawerViewModel(title: "Report Issues/ Feedback", logoImage: #imageLiteral(resourceName: "drawerFeedback"), logoSeletedImage: #imageLiteral(resourceName: "drawerFeedbackSelected"), arrowImage: nil, modelType: .feedback, modelIndex: 5)
        
        // Logout
        let logout = DrawerViewModel(title: "Logout", logoImage: #imageLiteral(resourceName: "drawerLogout"), logoSeletedImage: #imageLiteral(resourceName: "drawerLogoutSelected"), arrowImage: nil, modelType: .logout, modelIndex: 6)
        
        drawerList = [home, report, fav, alerts, settings, feedback, logout]
        return drawerList
    }
}
