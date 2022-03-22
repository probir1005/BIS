//
//  TableCollectionViewLayout.swift
//  BIS
//
//  Created by TSSIT on 16/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit

class SpreadSheetCollectionViewLayout: UICollectionViewLayout {
    
    var itemSize = CGSize(width: 200, height: 33.0)
    var attributesList = [UICollectionViewLayoutAttributes]()
    var headerAttributesList = UICollectionViewLayoutAttributes()
    var widthOfColumns = [CGFloat]()
    
    override func prepare() {
        super.prepare()
        
        let itemNo = collectionView?.numberOfItems(inSection: 0) ?? 0
        
        let totalWidth = widthOfColumns.reduce(0) { (result, new) -> CGFloat in
            return result + new
        }
        let headerWidth = max(totalWidth, collectionView!.bounds.width)
        
        let headerAttr = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(item: 0, section: 0))
        headerAttr.size = CGSize(width: headerWidth, height: 33)
        headerAttr.frame = CGRect(x: 0, y: 0, width: headerWidth, height: 33)
        attributesList = (0..<itemNo).map { (i) -> UICollectionViewLayoutAttributes in
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
            
            let widthIndex = i%widthOfColumns.count
            
            let x = widthOfColumns.prefix(upTo: widthIndex).reduce(0, +)
            let y = CGFloat(i/widthOfColumns.count)*(itemSize.height)
            var width = widthOfColumns[widthIndex]

            if widthIndex == widthOfColumns.count - 1 {
                let totalWidth = x+width
                let contentWidth = collectionView!.frame.width
                if contentWidth > totalWidth {
                    width = contentWidth - x
                }
            }
            
            itemSize = CGSize(width: width, height: 33.0)
            attributes.size = self.itemSize
        
            attributes.frame = CGRect(x: x, y: y, width: itemSize.width, height: itemSize.height)
            return attributes
        }
        
        attributesList.append(headerAttr)
        headerAttributesList  = headerAttr
    }
    
    override var collectionViewContentSize: CGSize {
        
        if widthOfColumns.count > 0 {
            let totalWidth = widthOfColumns.reduce(0) { (result, new) -> CGFloat in
                return result + new
            }
            let width = max(totalWidth, collectionView!.bounds.width)
            return CGSize(width: width, height: itemSize.height*CGFloat.init(integerLiteral: collectionView!.numberOfItems(inSection: 0)/widthOfColumns.count))
        } 
        return CGSize.zero
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        var answer = attributesList

        let missingSections = NSMutableIndexSet()
        for var idx in 0..<(answer.count ) {
            let layoutAttributes = answer[idx]

            if layoutAttributes.representedElementCategory == .cell {
                missingSections.add(layoutAttributes.indexPath.section ) // remember that we need to layout header for this section
            }
            if layoutAttributes.representedElementKind == UICollectionView.elementKindSectionHeader {
                answer.remove(at: idx) 
                idx -= 1
            }
        }

        missingSections.enumerate({ idx, _ in
            let indexPath = IndexPath(item: 0, section: idx)
            let layoutAttributes = self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath)
            if layoutAttributes != nil {
                if let layoutAttributes = layoutAttributes {
                    answer.append(layoutAttributes)
                }
            }
        })

        return answer
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if indexPath.row < attributesList.count {
            return attributesList[indexPath.row]
        }
        return nil
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

        let attributes = headerAttributesList
        if elementKind == UICollectionView.elementKindSectionHeader {
            let cv = collectionView
            let contentOffset = cv?.contentOffset
            var nextHeaderOrigin = CGPoint(x: Double.infinity, y: Double.infinity)
            
            if indexPath.section + 1 < (cv?.numberOfSections ?? 0) {
                let nextHeaderAttributes = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: IndexPath(item: 0, section: indexPath.section + 1))
                nextHeaderOrigin = nextHeaderAttributes?.frame.origin ?? CGPoint.zero
            }
            
            var frame = attributes.frame
            frame.origin.y = CGFloat(min(max(contentOffset!.y, frame.origin.y), nextHeaderOrigin.y - (frame.height )))
            attributes.zIndex = 1024
            attributes.frame = frame
        }
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
