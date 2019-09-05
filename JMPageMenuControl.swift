//
//  ScrollPageMenuControl.swift
//  SalonWalker
//
//  Created by Daniel on 2018/3/26.
//  Copyright © 2018年 skywind. All rights reserved.
//

import UIKit

public protocol JMPageMenuControlDelegate: class {
    func didSelectetPageAt(_ pageIndex: Int)
}

public class JMPageMenuControl: NSObject {

    private weak var scrollView: UIScrollView?
    private weak var topView: JMTopMenuView?
    private weak var delegate: JMPageMenuControlDelegate?
    private var pageMenuConfiguration: JMMenuConfiguration?
    private var hasAlreadyResize = false
    
    private var currentPage: Int = 0
    
    private var titles : [String] = []
    private var sliderColor: UIColor?
    private var lastContentOffset : CGFloat = 0.0
    
    private var childVCs: [UIViewController] = [] {
        didSet {
            let count: Int = childVCs.count
            scrollView?.contentSize = CGSize(width: scrollView!.frame.size.width * CGFloat(count), height: 0)
            for i in 0..<count {
                let vc = childVCs[i]
                vc.view.frame = CGRect(x: scrollView!.frame.size.width * CGFloat(i), y: 0, width: scrollView!.frame.size.width, height: scrollView!.frame.size.height)
                vc.view.layoutIfNeeded()
                scrollView?.addSubview(vc.view)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public func setupPageViewWith(topView: JMTopMenuView, scrollView: UIScrollView, childVCs: [UIViewController],pageMenuConfiguration: JMMenuConfiguration, baseVC: UIViewController, delegate: JMPageMenuControlDelegate?){
        
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.delaysContentTouches = false
        
        baseVC.view.layoutIfNeeded()
        
        self.topView = topView
        self.scrollView = scrollView
        self.pageMenuConfiguration = pageMenuConfiguration
        self.childVCs = childVCs
        self.titles = []
        for vc in childVCs {
            baseVC.addChild(vc)
            self.titles.append(vc.title ?? "no title?")
        }
        self.delegate = delegate
        
        self.topView?.setupViewWith(titles: titles, selectPageIndex: currentPage, pageMenuConfiguration: pageMenuConfiguration, delegate: self)

        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: UIDevice.orientationDidChangeNotification, object: UIDevice.current)
    }
    
    public func changeCurrentPage(_ index: Int) {
        currentPage = index
        topView?.selectedPageIndex = index
        scrollToCurrentIndex()
    }
    
    public func getCurrentPage() -> Int {
        return currentPage
    }
    
    /// call this function to resize scrollview contentsize and controller view size in  viewDidLayoutSubviews
    func resizeFrame() {
        
        if let scrollView = scrollView, !hasAlreadyResize {
            scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(childVCs.count), height: 0)
            for i in 0..<childVCs.count {
                let vc = childVCs[i]
                vc.view.frame = CGRect(x: scrollView.frame.size.width * CGFloat(i), y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
                vc.view.layoutIfNeeded()
            }
            topView?.resizeFrame()
            hasAlreadyResize = true
        }
    }
    
    @objc func orientationChanged(_ note: Notification?) {
        // 重設UI frame
        
        let point = CGPoint(x: scrollView!.frame.size.width * CGFloat(topView!.selectedPageIndex), y: 0)
        scrollView!.setContentOffset(point, animated: false)
        topView?.resizeFrame()
        
        for i in 0..<childVCs.count {
            let vc: UIViewController? = childVCs[i]
            vc?.view.frame = CGRect(x: scrollView!.frame.size.width * CGFloat(i), y: 0, width: scrollView!.frame.size.width, height: scrollView!.frame.size.height)
            vc?.view.layoutIfNeeded()
        }
        
        scrollView?.contentSize.width = scrollView!.frame.size.width * CGFloat(titles.count)
    }
    
    private func scrollToCurrentIndex() {
        let width = scrollView!.frame.size.width * CGFloat(currentPage)
        let point = CGPoint(x: width, y: 0)
        scrollView?.setContentOffset(point, animated: true)
    }
}

extension JMPageMenuControl: UIScrollViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastContentOffset = scrollView.contentOffset.x
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        topView?.moveSliderView(by: scrollView)
        
        
        let currentX = getScrollPageOffset(in: scrollView.contentOffset.x, width: scrollView.frame.width)
        let lastX = getScrollPageOffset(in: lastContentOffset, width: scrollView.frame.width)
        
        let center = scrollView.frame.width / 2
        if currentX < center && center <= lastX {
            print(scrollView.contentOffset.x / scrollView.frame.size.width)
            let currentPageIndex = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
            print(currentPageIndex)
            topView?.selectedPageIndex = currentPageIndex

        }else if currentX > center && center >= lastX {
            print(scrollView.contentOffset.x / scrollView.frame.size.width)

            let currentPageIndex = Int(scrollView.contentOffset.x / scrollView.frame.size.width) + 1
            print(currentPageIndex)
            topView?.selectedPageIndex = currentPageIndex

        }
        
        lastContentOffset = scrollView.contentOffset.x
    }
    
    func getScrollPageOffset(in x:CGFloat,width:CGFloat) -> CGFloat {
        var pageOffset:CGFloat = x
        while pageOffset >= width {
            pageOffset -= width
        }
        return pageOffset
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let lastPageIndex = currentPage
        currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        topView?.selectedPageIndex = currentPage
        if lastPageIndex != currentPage {
            delegate?.didSelectetPageAt(currentPage)
        }
    }
}

extension JMPageMenuControl: JMTopMenuViewDelegate {
    
    public func didSelectedAt(_ index: Int) {
        let lastPageIndex = currentPage
        currentPage = index
        scrollToCurrentIndex()
        if lastPageIndex != currentPage {
            delegate?.didSelectetPageAt(currentPage)
        }
    }
}

