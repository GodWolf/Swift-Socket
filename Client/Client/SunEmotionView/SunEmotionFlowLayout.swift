//
//  SunEmotionFlowLayout.swift
//  Client
//
//  Created by 孙兴祥 on 2017/7/18.
//  Copyright © 2017年 sunxiangxiang. All rights reserved.
//

import UIKit

class SunEmotionFlowLayout: UICollectionViewFlowLayout {

    var rowCount : Int = 3
    var columnCount : Int = 7
    
    fileprivate lazy var maxWidth : CGFloat = 0
    
    fileprivate lazy var attributes : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
}

extension SunEmotionFlowLayout {

    override func prepare() {
        super.prepare()
        
        let itemWidth = (collectionView!.bounds.width - sectionInset.left - sectionInset.right - minimumInteritemSpacing*CGFloat(columnCount-1))/CGFloat(columnCount)
        let itemHeight = (collectionView!.bounds.height - sectionInset.top - sectionInset.bottom - minimumLineSpacing*CGFloat(rowCount-1))/CGFloat(rowCount)
        
        var totalPage = 0
        let sectionCount = collectionView!.numberOfSections
        for section in 0..<sectionCount {
        
            let itemCount = collectionView!.numberOfItems(inSection: section)
            for item in 0..<itemCount {
            
                let page = item / (rowCount*columnCount)
                let index = item % (rowCount*columnCount)
                
                let indexPath = IndexPath(item: item, section: section)
                let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                let itemX = CGFloat(totalPage+page)*collectionView!.bounds.width+sectionInset.left+(itemWidth+minimumLineSpacing)*CGFloat(index%columnCount)
                let itemY = sectionInset.top+(itemHeight+minimumInteritemSpacing)*CGFloat(index/columnCount)
                attr.frame = CGRect(x: itemX, y: itemY, width: itemWidth, height: itemHeight)
                attributes.append(attr)
            }
            
            totalPage += (itemCount-1)/(rowCount*columnCount)+1
        }
        maxWidth = CGFloat(totalPage)*collectionView!.bounds.width
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return attributes
    }
    
    override var collectionViewContentSize: CGSize {
        
        return CGSize(width: maxWidth, height: collectionView!.bounds.height)
    }
    
}
