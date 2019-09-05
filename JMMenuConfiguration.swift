//
//  CAPSPageMenuConfiguration.swift
//  PageMenuConfigurationDemo
//
//  Created by Matthew York on 3/5/17.
//  Copyright © 2017 Aeron. All rights reserved.
//

import UIKit
public enum MenuItemWidthType {
    case fixedWidth
    case autoWidth
}

public class JMMenuConfiguration {
    open var menuItemWidthType : MenuItemWidthType = .fixedWidth
    open var menuItemWidth : CGFloat = 100.0

    open var selectedMenuItemLabelColor : UIColor = UIColor.white
    open var unselectedMenuItemLabelColor : UIColor = UIColor.lightGray
    open var selectedMenuItemFont : UIFont = UIFont.systemFont(ofSize: 15.0)
    open var unselectedMenuItemFont : UIFont = UIFont.systemFont(ofSize: 15.0)
    
    open var scrollAnimationDurationOnMenuItemTap : Int = 500 // Millisecons

    open var indicatorColor : UIColor = UIColor.white
    open var indicatorHeight : CGFloat = 3.0

    open var menuBackgroundColor : UIColor = UIColor.black

    
    open var menuHeight : CGFloat = 34.0
    open var menuMargin : CGFloat = 15.0
    

    open var viewBackgroundColor : UIColor = UIColor.white
    open var bottomMenuHairlineColor : UIColor = UIColor.white
    open var menuItemSeparatorColor : UIColor = UIColor.lightGray
    
    open var menuItemSeparatorPercentageHeight : CGFloat = 0.2
    open var menuItemSeparatorWidth : CGFloat = 0.5
    open var menuItemSeparatorRoundEdges : Bool = false
    
    open var addBottomMenuHairline : Bool = true
    open var menuItemWidthBasedOnTitleTextWidth : Bool = false
    open var titleTextSizeBasedOnMenuItemWidth : Bool = false
    open var useMenuLikeSegmentedControl : Bool = false
    open var centerMenuItems : Bool = false
    open var enableHorizontalBounce : Bool = true
    open var hideTopMenuBar : Bool = false
    
    public init() {
        
    }
    
    
    
//    self.sliderColor = sliderColor
//    self.titleColor = titleColor
//    self.titleSelectedColor = titleSelectedColor
//    self.titleFont = titleFont
//    self.titleSelectedFont = titleSelectedFont

}
