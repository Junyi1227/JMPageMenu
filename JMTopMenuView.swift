//
//  TopMenuView.swift
//  SalonWalker
//
//  Created by Daniel on 2018/3/23.
//  Copyright © 2018年 skywind. All rights reserved.
//

import UIKit

public protocol JMTopMenuViewDelegate: class {
    func didSelectedAt(_ index: Int)
}

public class JMTopMenuView: UIView {

    private weak var delegate: JMTopMenuViewDelegate?
    private var pageMenuConfiguration: JMMenuConfiguration = JMMenuConfiguration()
    private var collectionView: UICollectionView?
    private var itemWidth: CGFloat {
        get {
            if pageMenuConfiguration.menuItemWidthType == .autoWidth{
                return self.frame.size.width / CGFloat(titles.count)
            }else {
                return pageMenuConfiguration.menuItemWidth
            }
        }
    }
    
    private var titles: [String] = []
    private var sliderView: UIView?
    private var sliderHeight: CGFloat = 3.0
    
    private var sliderY: CGFloat {
        get {
            return self.frame.size.height - sliderHeight
        }
    }
    
    private var sliderColor: UIColor?
    func moveSliderView(by scrollView : UIScrollView) {
        self.sliderView?.frame = CGRect(x: self.itemWidth * CGFloat(scrollView.contentOffset.x/scrollView.frame.width),
                                        y: self.sliderY,
                                        width: self.itemWidth,
                                        height: self.sliderHeight)
        
    }
    
    var selectedPageIndex: Int = 0 {
        didSet {
            if self.titles.count != 0 {
                collectionView?.reloadData()
            }
        }
    }
    
    public func setupViewWith(titles: [String], selectPageIndex: Int,pageMenuConfiguration: JMMenuConfiguration, delegate: JMTopMenuViewDelegate?) {
        self.backgroundColor = pageMenuConfiguration.menuBackgroundColor
        
        self.delegate = delegate
        self.titles = titles
        self.selectedPageIndex = selectPageIndex
        self.pageMenuConfiguration = pageMenuConfiguration
        self.sliderHeight = pageMenuConfiguration.indicatorHeight
        
        self.setupView()
    }
    
    private func setupView() {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: collectionViewLayout)
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        //TODO:之後改成可變動的
        let bundle = Bundle(for: JMTopMenuViewBaseCell.self)
        collectionView?.register(UINib(nibName: "JMTopMenuViewBaseCell", bundle: bundle), forCellWithReuseIdentifier: "JMTopMenuViewBaseCell")
        self.addSubview(collectionView!)
        
        sliderView = UIView(frame: CGRect(x: itemWidth * CGFloat(selectedPageIndex), y: sliderY, width: itemWidth , height: sliderHeight))
        sliderView?.backgroundColor = sliderColor
        self.collectionView?.addSubview(sliderView!)
    }
    
    
    func resizeFrame() {
        self.collectionView?.frame = self.bounds
        self.collectionView?.collectionViewLayout.invalidateLayout()
        self.sliderView?.frame = CGRect(x: self.itemWidth * CGFloat(self.selectedPageIndex), y: self.sliderY, width: self.itemWidth, height: self.sliderHeight)
    }
    
}

extension JMTopMenuView: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index: Int = indexPath.row
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JMTopMenuViewBaseCell", for: indexPath) as! JMTopMenuViewBaseCell
        cell.titleLabel?.text = titles.count > index ? titles[index] : ""
        
        if index == selectedPageIndex {
            cell.titleLabel?.font = pageMenuConfiguration.selectedMenuItemFont
            cell.titleLabel?.textColor = pageMenuConfiguration.selectedMenuItemLabelColor
            cell.isSelected = true
        } else {
            cell.titleLabel?.font = pageMenuConfiguration.unselectedMenuItemFont
            cell.titleLabel?.textColor = pageMenuConfiguration.unselectedMenuItemLabelColor
            cell.isSelected = false
        }
        return cell
    }
}

extension JMTopMenuView: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedPageIndex = indexPath.row
        delegate?.didSelectedAt(indexPath.row)
    }
}

extension JMTopMenuView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemWidth, height: self.frame.size.height - sliderHeight)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
