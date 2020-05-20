//
//  YXCollectionViewLeftFlowLayout.swift
//  YXEDU
//
//  Created by Jake To on 2/27/20.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXCollectionViewLeftFlowLayout: UICollectionViewFlowLayout, UICollectionViewDelegateFlowLayout {
    var contentHeight: CGFloat = 0
    
    override func prepare() {
        super.prepare()
        
        contentHeight = fetchContentHeight()
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard scrollDirection == .vertical, let attributes = super.layoutAttributesForElements(in: rect) else { return super.layoutAttributesForElements(in: rect) }

        for index in 0..<attributes.count {

            if index == 0 {
                let firstAttribute = attributes[index]
                firstAttribute.frame = CGRect(x: self.sectionInset.left, y: firstAttribute.frame.minY, width: firstAttribute.frame.width, height: firstAttribute.frame.height)

            }

            if index != attributes.count - 1 {
                let currentAttribute = attributes[index]
                let nextAttribute = attributes[index + 1]

                if currentAttribute.frame.minY == nextAttribute.frame.minY, nextAttribute.frame.minX - currentAttribute.frame.maxX > minimumInteritemSpacing {
                    let x = currentAttribute.frame.maxX + minimumInteritemSpacing
                    nextAttribute.frame = CGRect(x: x, y: nextAttribute.frame.minY, width: nextAttribute.frame.width, height: nextAttribute.frame.height)
                }
            }

            if index - 1 >= 0 {
                let currentAttribute = attributes[index]
                let previousAttribute = attributes[index - 1]

                if currentAttribute.frame.minY != previousAttribute.frame.minY {
                    currentAttribute.frame = CGRect(x: self.sectionInset.left, y: currentAttribute.frame.minY, width: currentAttribute.frame.width, height: currentAttribute.frame.height)
                }
            }
        }
        
        return attributes
    }
    
    private func fetchContentHeight() -> CGFloat {
        let itemHeight: CGFloat = 30
        var contentHeight: CGFloat = self.minimumLineSpacing + itemHeight + self.minimumLineSpacing
        var numberOfLines = 0
        
        guard let numberOfItems = self.collectionView?.numberOfItems(inSection: 0) else { return contentHeight }
        
        for index in 0..<numberOfItems {
            if index != numberOfItems - 1 {
                guard let currentAttribute = self.layoutAttributesForItem(at: [0, index]) else { return 0 }
                guard let nextAttribute = self.layoutAttributesForItem(at: [0, index + 1]) else { return contentHeight }
                numberOfLines = numberOfLines == 0 ? 1 : numberOfLines

                if currentAttribute.frame.minY != nextAttribute.frame.minY {
                    numberOfLines = numberOfLines + 1
                }
            }
        }
        
        if numberOfLines > 1 {
            contentHeight = self.minimumLineSpacing + (itemHeight + self.minimumLineSpacing) * CGFloat(numberOfLines)
        }
        
        return contentHeight
    }
}
