//
//  SunTitleView.swift
//  Client
//
//  Created by 孙兴祥 on 2017/7/18.
//  Copyright © 2017年 sunxiangxiang. All rights reserved.
//

import UIKit


protocol SunTitleViewDelegate : class {

    func indexChange(_ index : Int)
}

class SunTitleView: UIScrollView {
    
    weak var titleDelegate : SunTitleViewDelegate?
    fileprivate let titles : [String]
    fileprivate let style : SunTitleStyle
    fileprivate lazy var labels : [UILabel] = [UILabel]()
    fileprivate var currentIndex : Int = 0
    
    init(frame: CGRect, titles : [String], style : SunTitleStyle) {
        
        self.titles = titles
        self.style = style
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: 设置界面
extension SunTitleView {
    
    fileprivate func setupUI() {
    
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.bounces = style.isBounce
        self.backgroundColor = style.backgroundColor
        createLabels()
    }
    
    /// 创建label
    fileprivate func createLabels() {
        
        guard titles.count > 0 else {
            return
        }
    
        var origin_x = style.sectionInset.left
        let top = style.sectionInset.top
        let height = bounds.height - style.sectionInset.top - style.sectionInset.bottom
        let size = CGSize(width: CGFloat(MAXFLOAT), height: height)
        for (index,str) in titles.enumerated()  {
            
            let label = UILabel()
            label.font = style.titleFont
            label.textAlignment = .center
            label.textColor = (index == 0 ? style.selectedColor : style.normaleColor)
            label.text = titles[index]
            label.tag = index
            addSubview(label)
            labels.append(label)
            
            var width : CGFloat = 0
            if style.isScroll == true {
                
                width = (str as NSString).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:style.titleFont], context: nil).width + 10
            }else {
                
                width = (bounds.width-style.sectionInset.left-style.sectionInset.right-style.itemSpace*CGFloat(titles.count-1))/CGFloat(titles.count)
            }
            label.frame = CGRect(x: origin_x, y: top, width: width, height: height)
            
            origin_x += (style.itemSpace + width)
            
            /// 添加手势
            label.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickLabel(_:)))
            label.addGestureRecognizer(tapGesture)
        }
        self.contentSize = CGSize(width: origin_x, height: bounds.height)
    }
}



//MARK: 点击事件
extension SunTitleView {

    @objc fileprivate func clickLabel(_ tapGesture : UITapGestureRecognizer) {
        
        let clickLabel = tapGesture.view as! UILabel
        
        scrollToLabel(clickLabel)
        titleDelegate?.indexChange(currentIndex)
    }
    
    fileprivate func scrollToLabel(_ directionLabel : UILabel) {
    
        guard currentIndex != directionLabel.tag else {
            return
        }
        let oldLabel = labels[currentIndex]
        currentIndex = directionLabel.tag
        
        UIView.animate(withDuration: 0.15) {
            
            oldLabel.textColor = self.style.normaleColor
            directionLabel.textColor = self.style.selectedColor
        }
        
        guard style.isScroll == true else {
            return
        }
        
        let offsetX = directionLabel.frame.origin.x - (currentIndex == 0 ? style.sectionInset.left : style.itemSpace)
        
        guard offsetX < bounds.width else{
            
            let minX = min(offsetX, contentSize.width-bounds.width)
            setContentOffset(CGPoint(x: minX, y: 0), animated: true)
            return
        }
        
        if contentSize.width-offsetX >= bounds.width {
            setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        }
    }
}

//MARK: 外部方法
extension SunTitleView {

    func scrollToItem(_ index : Int) {
    
        guard (index >= 0) && (index < labels.count) else {
            return
        }
        scrollToLabel(labels[index])
    }
}



