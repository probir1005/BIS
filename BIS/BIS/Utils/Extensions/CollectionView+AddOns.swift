//
//  CollectionView+AddOns.swift
//  BIS
//
//  Created by TSSIT on 27/05/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func register<T>(cell: T.Type) where T: ReuseIdentifier, T: UICollectionViewCell, T: NibLoadableView {
        register(UINib(nibName: T.nibName, bundle: nil), forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T>(indexPath: IndexPath) -> T where T: UICollectionViewCell, T: ReuseIdentifier {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("\(type(of: self)) Could not dequeue cell with identifier \(T.reuseIdentifier)")
        }
        return cell
    }
    
    func register(nib: String) {
        register(UINib(nibName: nib, bundle: nil), forCellWithReuseIdentifier: nib)
    }
    
    func register(nib: String, forCellReuseIdentifier identifier: String) {
        register(UINib(nibName: nib, bundle: nil), forCellWithReuseIdentifier: identifier)
    }
    
    func register(nib: String, forSupplementaryViewOfKind kind: String, withReuseIdentifier identifier: String) {
        register(UINib(nibName: nib, bundle: nil), forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
    }
}
