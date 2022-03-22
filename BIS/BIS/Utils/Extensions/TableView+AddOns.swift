//
//  TableView+AddOns.swift
//  BIS
//
//  Created by TSSIT on 27/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

// MARK: - ReuseIdentifier 
protocol ReuseIdentifier: class {
    
}

extension ReuseIdentifier where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

// MARK: - NibLoadableView 
protocol NibLoadableView: class {
    
}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
}

// MARK: - UITableView
extension UITableView {
    
    func register<T>(cell: T.Type) where T: ReuseIdentifier, T: UITableViewCell, T: NibLoadableView {
        register(UINib(nibName: T.nibName, bundle: nil), forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T>(indexPath: IndexPath) -> T where T: UITableViewCell, T: ReuseIdentifier {
        guard  let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("\(type(of: self)) Could not dequeue cell with identifier \(T.reuseIdentifier)")
        }
        return cell
    }
    
    func removeDefaultPaddingForGrouped() {
        tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 8.0))
        tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 8.0))
    }
}

extension UITableView {
    func setHeaderView(_ headerView: UIView) {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        tableHeaderView = headerView
        
        let centerXConstraint = NSLayoutConstraint(item: headerView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: headerView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: headerView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
//        let bottomConstraint = NSLayoutConstraint(item: headerView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([centerXConstraint, widthConstraint, topConstraint])
        
        tableHeaderView?.layoutIfNeeded()
    }
    
    func register(nib: String, forCellReuseIdentifier identifier: String) {
        register(UINib(nibName: nib, bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    func register(nib: String, forHeaderFooterViewReuseIdentifier identifier: String) {
        self.register(UINib(nibName: nib, bundle: nil), forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    func registerHeader(withIdentifier identifier: String) {
        register(UINib(nibName: identifier, bundle: nil), forHeaderFooterViewReuseIdentifier: identifier)
    }
}
