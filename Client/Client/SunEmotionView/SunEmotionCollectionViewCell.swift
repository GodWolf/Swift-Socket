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
            DispatchQueue.global().async {
                let image = UIImage(named: self.emotionModel!.emotionName)
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
            
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
