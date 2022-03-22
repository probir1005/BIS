//
//  Literals.swift
//  BIS
//
//  Created by TSSIT on 28/07/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import Foundation

enum Strings {
    
    enum ScreenTitle {
        static let help = "Help"
        static let home = "Home"
        static let favourites = "Favourites"
        static let alerts = "Alerts"
        static let report = "Sales Report"
        static let details = "Details"
        static let annotation = "Annotate"
        static let manageAlerts = "Manage alerts"
        static let settingAlert = "Setting alert"
    }
    
    enum AlertTitle {
        static let discardChanges = "Discard Changes?"
        static let manageAlerts = "Manage alerts"
    }
    
    enum AlertMessage {
        static let reloading = "Reloading..."
        static let goBack = "Do you want to go back?"
        static let deleteAlert = "Are you sure, you want to delete this alert?"
    }
    
    enum ButtonTitle {
        static let yes = "YES"
        static let no = "NO"
        static let cancel = "Cancel"
    }
    
    enum SplashVC {
        static let business = "BUSINESS"
    }
    
    enum HelpVC {
        static let heading = "Quick Help"
        static let descriptions = "Find difficulty to sign in or operating the app, please send your queries and valuable feedback to us at support@tumlare.com, we'll assure you to do the appropriate measures as earliest as possible."
    }
    
    enum ManageAlerts {
        static let alertTitle = "ALERT TITLE"
        static let alertsFor = "Alert for %@"
        static let condition = "CONDITION"
        
    }
}
