//
//  CellLayout.swift
//  Color
//
//  Created by Caelan Dailey on 8/3/17.
//  Copyright © 2017 Caelan Dailey. All rights reserved.
//

import Foundation
import UIKit

class ColorCellLayout : UICollectionViewFlowLayout {
    
    var itemWidth : CGFloat
    var itemHeight : CGFloat
    
    var columns: Int{
        return self.collectionView!.numberOfItems(inSection: 0)
    }
    var rows: Int{
        return self.collectionView!.numberOfSections
    }
    
    init(itemWidth: CGFloat, itemHeight: CGFloat) {
        self.itemWidth = itemWidth
        self.itemHeight = itemHeight
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        self.itemWidth = 25
        self.itemHeight = 25
        
        super.init()
    }
    
    override var collectionViewContentSize: CGSize{
        let w : CGFloat = CGFloat(columns) * (itemWidth)
        let h : CGFloat = CGFloat(rows) * (itemHeight)
        return CGSize(width: w, height: h)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let x : CGFloat = CGFloat(indexPath.row) * (itemWidth)
        let y : CGFloat = CGFloat(indexPath.section) * (itemHeight) + 64
        attributes.frame = CGRect(x: x, y: y, width: itemWidth, height: itemHeight)
        return attributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let minRow : Int = (rect.origin.x > 0) ? Int(floor(rect.origin.x/(itemWidth))) : 0
        let maxRow : Int = min(columns - 1, Int(ceil(rect.size.width / (itemWidth)) + CGFloat(minRow)))
        var attributes : Array<UICollectionViewLayoutAttributes> = [UICollectionViewLayoutAttributes]()
        for i in 0 ..< rows {
            for j in minRow ... maxRow {
                attributes.append(self.layoutAttributesForItem(at: IndexPath(item: j, section: i))!)
            }
        }
        return attributes
    }
}


