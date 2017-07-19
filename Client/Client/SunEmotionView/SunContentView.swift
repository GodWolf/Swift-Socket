//
//  SunContentView.swift
//  Client
//
//  Created by 孙兴祥 on 2017/7/19.
//  Copyright © 2017年 sunxiangxiang. All rights reserved.
//

import UIKit

protocol SunContentViewDataSource : class {
    func numberOfSections(in collectionView: UICollectionView) -> Int
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}

protocol SunContentViewDelegate : class {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
}

class SunContentView: UIView {

    weak var dataSource : SunContentViewDataSource?
    weak var delegate : SunContentViewDelegate?
    fileprivate var titles : [String]
    fileprivate var titleStyle : SunTitleStyle
    fileprivate var layout : SunEmotionFlowLayout
    fileprivate var titleView : SunTitleView!
    fileprivate var collectionView : UICollectionView!
    fileprivate var pageContrl : UIPageControl!
    fileprivate var sourceSection : Int = 0
    
    init(frame: CGRect,titles : [String],titleStyle : SunTitleStyle,layout : SunEmotionFlowLayout) {
        
        self.titles = titles
        self.titleStyle = titleStyle
        self.layout = layout
        
        super.init(frame: frame)
        backgroundColor = UIColor.black
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}



extension SunContentView {
    
    fileprivate func setupUI() {
    
        setupTitleView()
        setupColletionView()
        setupPageControl()
    }
    
    fileprivate func setupTitleView() {
        
        let titleFrame = CGRect(x: 0, y: 0, width: bounds.width, height: titleStyle.titleHeight)
        titleView = SunTitleView(frame:titleFrame , titles: titles, style: titleStyle)
        titleView.titleDelegate = self
        addSubview(titleView)
    }
    
    fileprivate func setupColletionView() {
    
        layout.scrollDirection = .horizontal
        let collectionFrame = CGRect(x: 0, y: titleView.frame.maxY, width: bounds.width, height: bounds.height-titleView.bounds.height-20)
        collectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        addSubview(collectionView)
    }
    
    fileprivate func setupPageControl() {
    
        let pageFrame = CGRect(x: 0, y: collectionView.frame.maxY, width: bounds.width, height: 20)
        pageContrl = UIPageControl(frame: pageFrame)
        pageContrl.isEnabled = false
        pageContrl.numberOfPages = 1
        addSubview(pageContrl)
    }
}

// MARK:- 对外暴露的方法
extension SunContentView {
    func register(cell : AnyClass?, identifier : String) {
        collectionView.register(cell, forCellWithReuseIdentifier: identifier)
    }
    
    func register(nib : UINib, identifier : String) {
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
}

extension SunContentView : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return dataSource?.numberOfSections(in:collectionView) ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let itemCount = dataSource?.collectionView(collectionView, numberOfItemsInSection: section) ?? 0
        
        if section == 0 {
        
            pageContrl.numberOfPages = (itemCount-1)/(layout.rowCount*layout.columnCount)+1
        }
        
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return dataSource!.collectionView(collectionView, cellForItemAt: indexPath)
    }
}

//MARK: UICollectionViewDelegate
extension SunContentView : UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate?.collectionView(collectionView, didSelectItemAt: indexPath)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        scrollViewDidEndScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if decelerate == false {
        
            scrollViewDidEndScroll()
        }
    }
    
    fileprivate func scrollViewDidEndScroll() {
    
        let point = CGPoint(x: layout.sectionInset.left+collectionView.contentOffset.x+1, y: layout.sectionInset.top+1)
        let indexPath = collectionView.indexPathForItem(at: point)
        
        
        if indexPath!.section != sourceSection {
            
            sourceSection = indexPath!.section
            titleView.scrollToItem(sourceSection)
            
            let itemCount = dataSource?.collectionView(collectionView, numberOfItemsInSection: sourceSection) ?? 0
            pageContrl.numberOfPages = (itemCount-1)/(layout.rowCount*layout.columnCount)+1
        }
        
        pageContrl.currentPage = indexPath!.item/(layout.rowCount*layout.columnCount)
    }
}


//MARK: SunTitleViewDelegate
extension SunContentView : SunTitleViewDelegate {
    
    func indexChange(_ index: Int) {
        
        collectionView.scrollToItem(at: IndexPath(item: 0, section: index), at: .left, animated: true)
    }
}
