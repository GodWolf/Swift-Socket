//
//  SunTitleStyle.swift
//  Client
//
//  Created by 孙兴祥 on 2017/7/18.
//  Copyright © 2017年 sunxiangxiang. All rights reserved.
//

import UIKit

class SunTitleStyle: NSObject {
    
    
    /// 标题高度
    var titleHeight : CGFloat = 30
    
    /// 字体
    var titleFont : UIFont = UIFont.systemFont(ofSize: 20)
    
    /// 背景颜色
    var backgroundColor : UIColor = UIColor.gray
    
    /// 标题正常时颜色
    var normaleColor : UIColor = UIColor.black
    
    /// 标题选中时颜色
    var selectedColor : UIColor = UIColor.orange
    
    /// 是否反弹
    var isBounce : Bool = true
    
    /// 内边距
    var sectionInset : UIEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
    
    /// 标题之间的间距
    var itemSpace : CGFloat = 10;
    
    ///是否滚动
    var isScroll : Bool = true
}
