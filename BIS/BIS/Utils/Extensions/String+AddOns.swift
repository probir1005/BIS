//
//  String+AddOns.swift
//  BIS
//
//  Created by TSSIOS on 17/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

extension String {

    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }

    var trimmed: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var isEmail: Bool {
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
        return predicate.evaluate(with: self)
    }

    func condenseWhitespace() -> String {
        let components = self.components(separatedBy: .whitespaces)
        return components.filter { !$0.isEmpty }.joined(separator: " ").replacingOccurrences(of: "[\\r\n]+", with: "\n", options: .regularExpression, range: nil)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.width)
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    func isValidUserName() -> Bool {

        let nameRegEx = "^[a-zA-Z0-9\\s].{3,20}$"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: self)
    }

    func isValidPassword() -> Bool {
        let passwordRegEx = "^[A-Za-z0-9]+(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,20}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: self)
    }

    func contains(string: String) -> Bool {
        return self.range(of: string) != nil
    }

    func isValidName() -> Bool {

        let nameRegEx = "^[a-zA-Z\\s]+$"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: self)
    }

    func isValidEmail() -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self)
    }
}
