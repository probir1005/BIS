//
//  MaterialInputView.swift
//  BIS
//
//  Created by TSSIT on 20/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

protocol MaterialTextFieldDelegate: class {
    func textFieldDidBeginEditing(_ textField: UITextField)
    func textFieldDidEndEditing(_ textField: UITextField)
    func textFieldDidChangeCharacter(_ textField: UITextField, range: NSRange, string: String) -> Bool
    func textFieldShouldReturn(_ textField: UITextField)
}

extension MaterialTextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) { }
    func textFieldDidEndEditing(_ textField: UITextField) {}
    func textFieldDidChangeCharacter(_ textField: UITextField, range: NSRange, string: String) -> Bool {
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) {}
}

class MaterialInputView: UIView {
    
    weak var textFieldDelegate: MaterialTextFieldDelegate?
    
    var labelText: String = "" {
        didSet {
            label.text = labelText
        }
    }
    
    var textFieldText: String = "" {
        didSet {
            if !textFieldText.isEmpty {
                textField.text = textFieldText
                isUp = true
            }
        }
    }
    
    lazy var label: UILabel = {
        return UILabel()
    }()

    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.tintColor = .astronautBlue
        textField.textColor = .astronautBlue
        textField.font = BISFont.h16.regular
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no

        return textField
    }()

    lazy var line: UIView = {
        let line = UIView()
        line.backgroundColor = .darkGray1
        return line
    }()

    // Whether label should be moved to top
    private var isUp: Bool = false {
        didSet {
            styleLabel(isUp: isUp)
            moveLabel(isUp: isUp)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        self.addSubview(textField)
        self.addSubview(label)
        self.addSubview(line)
        
        textField.delegate = self
        
        self.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        // text view constraints
        NSLayoutConstraint.init(item: textField, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 32).isActive = true
        NSLayoutConstraint.init(item: textField, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -1).isActive = true
        NSLayoutConstraint.init(item: textField, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: textField, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -30).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        // Label constraints:
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.init(item: label, attribute: .top, relatedBy: .equal, toItem: textField, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: label, attribute: .leading, relatedBy: .equal, toItem: textField, attribute: .leading, multiplier: 1, constant: 5).isActive = true
        NSLayoutConstraint.init(item: label, attribute: .trailing, relatedBy: .equal, toItem: textField, attribute: .trailing, multiplier: 1, constant: 0).isActive = true

        self.bringSubviewToFront(label)
        
        // line constraints
        line.translatesAutoresizingMaskIntoConstraints = false
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        NSLayoutConstraint.init(item: line, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: line, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: line, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true

        styleLabel(isUp: false)
    }

    private func styleLabel(isUp: Bool) {
        UIView.transition(
            with: label,
            duration: 0.15,
            options: .curveEaseInOut,
            animations: {
                if isUp {
                    self.label.font = BISFont.h16.bold
                    self.label.textColor = .astronautBlue
                } else {
                    self.label.font = BISFont.h16.regular
                    self.label.textColor = .astronautBlue
                }
            },
            completion: nil
        )
    }

    private func moveLabel(isUp: Bool) {
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                if isUp {
//                    let offsetX = self.label.frame.width * 0.1
                    let translation = CGAffineTransform(translationX: -5, y: -30)
                    let scale = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    self.label.transform = translation.concatenating(scale)
                } else {
                    self.label.transform = .identity
                }
            },
            completion: nil
        )
    }
}

extension MaterialInputView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if !isUp {
            isUp = true
        }
        textFieldDelegate?.textFieldDidBeginEditing(textField)
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard let text = textField.text else {
            return false
        }

        if isUp && text.isEmpty {
            isUp = false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textFieldDelegate != nil {
            textFieldDelegate!.textFieldShouldReturn(textField)
            return false
        }
        self.endEditing(true)
        return false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldDelegate?.textFieldDidEndEditing(textField)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        return textFieldDelegate?.textFieldDidChangeCharacter(textField, range: range, string: string) ?? true
    }
}
