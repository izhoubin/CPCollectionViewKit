//
//  CPCollectionViewStageLayout.swift
//  CPCollectionViewKit
//
//  Created by Parsifal on 2017/2/17.
//  Copyright © 2017年 Parsifal. All rights reserved.
//

import Foundation

open class CPStageLayoutConfiguration: CPLayoutConfiguration {
    
}

open class CPCollectionViewStageLayout: CPCollectionViewLayout {
    
    public var configuration: CPStageLayoutConfiguration
    
    public init(withConfiguration configuration: CPStageLayoutConfiguration) {
        self.configuration = configuration
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.configuration =  CPStageLayoutConfiguration(withCellSize: CGSize(width: 100, height: 100))
        super.init(coder: aDecoder)
    }

    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItem(at: indexPath)!
        guard let collectionView = collectionView else { return  attributes}
        
        let item = CGFloat(indexPath.item)
        let width = collectionView.bounds.size.width
        let height = collectionView.bounds.size.height
        let cellSize = configuration.cellSize
        let cellHeight = cellSize.height
        let cellWidth = cellSize.width
        var centerX: CGFloat = 0.0
        var centerY: CGFloat = 0.0
        let topItemIndex = collectionView.contentOffset.x/cellWidth
        let itemOffset = item-topItemIndex
        
        attributes.isHidden = false
        attributes.size = cellSize
        
        if itemOffset > -1 && itemOffset<0 {
            attributes.alpha = fabs(itemOffset)
            centerX = collectionView.contentOffset.x+(fabs(itemOffset)+0.5)*width
            centerY = (height-cellHeight)/2
        } else if itemOffset<=1 && itemOffset>=0 {
            centerX = ((width-cellWidth)/2)*(1-itemOffset)+cellWidth/2+collectionView.contentOffset.x
            centerY = ((cellHeight/2-height)/(2))*(1-itemOffset)+height-cellHeight/2
        } else if itemOffset>1 {
            centerX = collectionView.contentOffset.x+(itemOffset-0.5)*cellWidth+(itemOffset-1)*configuration.spacing
            centerY = height-cellHeight/2
        } else {
            attributes.isHidden = true
            centerX = -width
            centerY = -height
        }
        
//        print("item:\(item) itemOffset:\(itemOffset) topItemIndex:\(topItemIndex)")
        
        attributes.center = CGPoint(x: centerX+configuration.offsetX,
                                    y: centerY+configuration.offsetY)
        
        return attributes
    }
    
    open override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return super.collectionViewContentSize }
        let cellWidth = configuration.cellSize.width
        let width = CGFloat(cellCount-1)*cellWidth+collectionView.bounds.height
        return CGSize(width: width, height: collectionView.bounds.height)
    }

}