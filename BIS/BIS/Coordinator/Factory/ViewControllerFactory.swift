//
//  ViewControllerFactory.swift
//  BIS
//
//  Created by TSSIOS on 14/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

class ViewControllerFactory {
    
    func instantiateSplashVC() -> BISSplashVC {
        let splashVC = BISSplashVC(nibName: String(describing: BISSplashVC.self), bundle: nil)
        return splashVC
    }

    func instantiateHelpViewController() -> BISHelpVC {
        let helpVC = BISHelpVC(nibName: String(describing: BISHelpVC.self), bundle: nil)
        return helpVC
    }

    func instantiateLoginViewController() -> BISSignInVC {
        let signInVC = BISSignInVC(nibName: String(describing: BISSignInVC.self), bundle: nil)
        BISSignInBuilder.buildModule(arroundView: signInVC)
        return signInVC
    }
    
    func instantiateBiometricsViewController() -> BISBiometricsVC {
        let biometricVC = BISBiometricsVC(nibName: String(describing: BISBiometricsVC.self), bundle: nil)
        return biometricVC
    }

    func instantiatePINVerifyViewController() -> BISPINVerifyVC {
        let pinVerifyVC = BISPINVerifyVC(nibName: String(describing: BISPINVerifyVC.self), bundle: nil)
        BISPINVerifyBuilder.buildModule(arroundView: pinVerifyVC)
        return pinVerifyVC
    }

    func instantiatePINRegisterViewController(pin: String?) -> BISPINRegisterVC {
        let pinRegisterVC = BISPINRegisterVC(nibName: String(describing: BISPINRegisterVC.self), bundle: nil)
        BISPINRRegisterBuilder.buildModule(arroundView: pinRegisterVC, pin: pin)
        return pinRegisterVC
    }

    func instantiateVerifyOTPViewController() -> BISVerifyOTPVC {
        let verifyOTPVC = BISVerifyOTPVC(nibName: String(describing: BISVerifyOTPVC.self), bundle: nil)
        BISVerifyOTPBuilder.buildModule(arroundView: verifyOTPVC)
        return verifyOTPVC
    }

    func instantiateChangePINViewController(pin: String?, savedPin: String?) -> BISChangePINVC {
        let changePinVC = BISChangePINVC(nibName: String(describing: BISChangePINVC.self), bundle: nil)
        BISChangePINBuilder.buildModule(arroundView: changePinVC, pin: pin, savedPin: savedPin)
        return changePinVC
    }

    func instantiateDashboardViewController(with centerController: BaseViewController, sidePanel: BaseViewController) -> CustomSidePanel {
        let navVC = CustomNavigationController(rootViewController: centerController)
        let sidePanel = CustomSidePanel(center: navVC, left: sidePanel)
        return sidePanel
    }

    func instantiateHomeViewController(controllers: [BISDashboardBaseVC]) -> BISHomeVC {
        let homeVC = BISHomeVC(nibName: String(describing: BISHomeVC.self), bundle: nil)
        BISHomeBuilder.buildModule(arroundView: homeVC, controllers: controllers)
        return homeVC
    }

    func instantiateFavouritesViewController() -> BISFavouritesVC {
        let favouritesVC = BISFavouritesVC(nibName: String(describing: BISFavouritesVC.self), bundle: nil)
        return favouritesVC
    }

    func instantiateAlertViewController() -> BISAlertsVC {
        let alertsVC = BISAlertsVC(nibName: String(describing: BISAlertsVC.self), bundle: nil)
        return alertsVC
    }

    func instantiateSettingsViewController() -> BISSettingsVC {
        let settingsVC = BISSettingsVC(nibName: String(describing: BISSettingsVC.self), bundle: nil)
        return settingsVC
    }

    func instantiateTabBarController(controllers: [CustomNavigationController]) -> BISTabBarVC {
        let tabBarVC = BISTabBarVC(controllers: controllers)
        return tabBarVC
    }

    func instantiatePrivacyViewController(title: String) -> BISPrivacyPolicyVC {
        let privacyVC = BISPrivacyPolicyVC(nibName: String(describing: BISPrivacyPolicyVC.self), bundle: nil)
        privacyVC.screenTitle = title
        return privacyVC
    }

    func instantiateAboutUSViewController() -> BISAboutUsVC {
           let aboutUsVC = BISAboutUsVC(nibName: String(describing: BISAboutUsVC.self), bundle: nil)
           return aboutUsVC
    }

    func instantiateFilterViewController() -> BISFilterVC {
           let filterVC = BISFilterVC(nibName: String(describing: BISFilterVC.self), bundle: nil)
           return filterVC
    }

    func instantiateChartDetailViewController(data: HomeChartDTO) -> BISChartDetailsVC {
        let chartDetailVC = BISChartDetailsVC(nibName: String(describing: BISChartDetailsVC.self), bundle: nil)
        chartDetailVC.chartData = data
        return chartDetailVC
    }
    
    func instantiateManagementViewController() -> BISManagementHomeVC {
        let managementVC = BISManagementHomeVC(nibName: String(describing: BISManagementHomeVC.self), bundle: nil)
        return managementVC
    }

    func instantiateSalesPICViewController() -> BISSalesPICHomeVC {
        let salesPICVC = BISSalesPICHomeVC(nibName: String(describing: BISSalesPICHomeVC.self), bundle: nil)
        return salesPICVC
    }

    func instantiateSalesPipelineViewController() -> BISOperationsHomeVC {
        let salesPipelineVC = BISOperationsHomeVC(nibName: String(describing: BISOperationsHomeVC.self), bundle: nil)
        return salesPipelineVC
    }
}
