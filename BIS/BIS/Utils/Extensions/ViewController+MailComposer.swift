//
//  ViewController+MailComposer.swift
//  BIS
//
//  Created by TSSIOS on 08/07/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit
import MessageUI

// https://stackoverflow.com/questions/25981422/how-to-open-mail-app-from-swift
extension UIViewController: MFMailComposeViewControllerDelegate {

    func sendTo(email: String) {

        // Show default mail composer
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
//            mail.setSubject(subject)
//            mail.setMessageBody(body, isHTML: false)

            present(mail, animated: true)

        // Show third party email composer if default Mail app is not present
        } else if let emailUrl = createEmailUrl(to: email) {
            UIApplication.shared.open(emailUrl)
        }
    }

    private func createEmailUrl(to: String) -> URL? {

        let gmailUrl = URL(string: "googlegmail://co?to=\(to)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)")
        let defaultUrl = URL(string: "mailto:\(to)")

        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }

        return defaultUrl
    }

    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }

}
