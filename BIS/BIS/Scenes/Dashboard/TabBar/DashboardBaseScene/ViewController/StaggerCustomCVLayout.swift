//
//  StaggerCustomCVLayout.swift
//  BIS
//
//  Created by TSSIT on 22/07/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

protocol StaggerLayoutDelegate: AnyObject {
    func staggerLayout( _ collectionView: UICollectionView, heightForPhotoAt indexPath: IndexPath) -> CGFloat
}

class StaggerCVLayout: UICollectionViewLayout {
    weak var delegate: StaggerLayoutDelegate?
    
    private var numberOfColumns = 2
    private let lineSpacing: CGFloat = 16
    private var cellSpacing: CGFloat = 0
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 1
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right) - cellSpacing
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        
        guard let collectionView = collectionView else {
            return
        }
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(column == 0 ? 0 : CGFloat(column) * columnWidth + cellSpacing)
        }
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        let itemNo = collectionView.numberOfItems(inSection: 0)
        cache = (0..<itemNo).map { (item) -> UICollectionViewLayoutAttributes in
            let indexPath = IndexPath(item: item, section: 0)
            
            let photoHeight = delegate?.staggerLayout( collectionView, heightForPhotoAt: indexPath) ?? 180
            let height = lineSpacing + photoHeight
            let frame = CGRect(x: xOffset[column],
                               y: yOffset[column],
                               width: columnWidth,
                               height: photoHeight)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
            return attributes
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) 
        -> [UICollectionViewLayoutAttributes]? {
            return cache
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) 
        -> UICollectionViewLayoutAttributes? {
            return cache[indexPath.item]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    func updateView() {
        if CustomNavigationController.appDelegate.landscape || UIDevice.current.orientation == .portraitUpsideDown {
            numberOfColumns = 2
            cellSpacing = 16
        } else {
            numberOfColumns = 1
            cellSpacing = 0
        }
        contentHeight = 0
    }
}
