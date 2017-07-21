//
//  SunEmotionView.swift
//  Client
//
//  Created by 孙兴祥 on 2017/7/19.
//  Copyright © 2017年 sunxiangxiang. All rights reserved.
//

import UIKit

fileprivate let CellIdentify = "SunEmotionCollectionViewCell"
class SunEmotionView: UIView {

    var selectBlock : ((SunEmotionModel) -> Void)?
    
    fileprivate lazy var emotions : [SunEmotionPackage] = SunEmotionPackage.getEmotions()
    fileprivate var emotionView : SunContentView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let titleStyle = SunTitleStyle()
        titleStyle.isScroll = false
        emotionView = SunContentView(frame: bounds, titles: ["普通表情","会员表情"], titleStyle: titleStyle, layout: SunEmotionFlowLayout())
        emotionView.dataSource = self
        emotionView.delegate = self
        emotionView.register(cell: SunEmotionCollectionViewCell.self, identifier: CellIdentify)
        addSubview(emotionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK: SunContentViewDataSource
extension SunEmotionView : SunContentViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return emotions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let package : SunEmotionPackage = emotions[section]
        
        return package.emotions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentify, for: indexPath) as! SunEmotionCollectionViewCell
        let package : SunEmotionPackage = emotions[indexPath.section]
        cell.emotionModel = package.emotions[indexPath.item]
        
        return cell
    }
}

//MARK: SunContentViewDelegate
extension SunEmotionView : SunContentViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let package = emotions[indexPath.section]
        
        guard let callBackBlock = selectBlock else {
            return
        }
        callBackBlock(package.emotions[indexPath.item])
    }
}
