//
//  SunEmotionCollectionViewCell.swift
//  Client
//
//  Created by 孙兴祥 on 2017/7/19.
//  Copyright © 2017年 sunxiangxiang. All rights reserved.
//

import UIKit

class SunEmotionCollectionViewCell: UICollectionViewCell {
    
    fileprivate var imageView : UIImageView!
    
    var emotionModel : SunEmotionModel? {
    
        didSet {
        
            imageView.image = UIImage(named: emotionModel!.emotionName)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: bounds)
        imageView.contentMode = .center
        imageView.backgroundColor = UIColor.clear
        contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
