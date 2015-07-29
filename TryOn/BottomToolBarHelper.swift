//
//  BottomToolBar.swift
//  TryOn
//
//  Created by QiFeng on 7/26/15.
//  Copyright © 2015 QiFeng. All rights reserved.
//

import Foundation
import UIKit


class BottomToolbarHelper {
    // Classify by filter type, i.e. round, Oval ..., which is sub type of tap btn
    class func filterBtn (glassesType: GlassesType, parentView: UIViewController, handler: Selector) -> UIBarButtonItem {
        var filterBtn: UIBarButtonItem!
        switch glassesType {
            case GlassesType.round:
                filterBtn = UIBarButtonItem(customView: self.setBtnImg(ImgLib.FiltersPhoto.round!, glassesType: glassesType, parentView: parentView, handler: handler))
                break
            case GlassesType.Oval:
                filterBtn = UIBarButtonItem(customView: self.setBtnImg(ImgLib.FiltersPhoto.Oval!, glassesType: glassesType, parentView: parentView, handler: handler))
                break
            case GlassesType.Dawn:
                filterBtn = UIBarButtonItem(customView: self.setBtnImg(ImgLib.FiltersPhoto._Dawn!, glassesType: glassesType, parentView: parentView, handler: handler))
                
                break
            case GlassesType.Proces:
                filterBtn = UIBarButtonItem(customView: self.setBtnImg(ImgLib.FiltersPhoto._Process!, glassesType: glassesType, parentView: parentView, handler: handler))
                break
            case GlassesType.Hefe:
                filterBtn = UIBarButtonItem(customView: self.setBtnImg(ImgLib.FiltersPhoto._Hefe!, glassesType: glassesType, parentView: parentView, handler: handler))
                break
            default:
                filterBtn = UIBarButtonItem(customView: self.setBtnImg(ImgLib.FiltersPhoto._Hefe!, glassesType: glassesType, parentView: parentView, handler: handler))
        }
        return filterBtn
    }
    
    class func setBtnImg(btnimg: UIImage, glassesType: GlassesType, parentView: UIViewController, handler: Selector) -> UIButton{
        let btn: UIButton = UIButton(frame: CGRectMake(0, 0, btnimg.size.width, btnimg.size.height))
        let bgLayer:UIView = UIView(frame: CGRectMake(0, btnimg.size.height - 12 , btnimg.size.width, 12))
        bgLayer.backgroundColor = ColorSpace.View.BarBtnItemTitleBgLayerBottomColor
        btn.addSubview(bgLayer)
        bgLayer.layer.zPosition = 0
        btn.titleEdgeInsets = UIEdgeInsetsMake(67.0 , 0.0, 0.0, 0.0 )
        btn.titleLabel?.font = UIFont.systemFontOfSize(CGFloat(11.0))
        btn.titleLabel?.layer.zPosition = 1
        btn.setTitle(glassesType.simpleDesp(), forState: UIControlState.Normal)
        btn.setBackgroundImage(btnimg, forState: UIControlState.Normal)
        btn.selected = false
        btn.addTarget(parentView, action: handler, forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }
    class func setBtnImgNatual(btnimg: UIImage, parentView: UIViewController, handler: Selector) -> UIButton{
        let btn: UIButton = UIButton(frame: CGRectMake(0, 0, btnimg.size.width, btnimg.size.height))
        let bgLayer:UIView = UIView(frame: CGRectMake(0, btnimg.size.height - 12 , btnimg.size.width, 12))
        bgLayer.backgroundColor = ColorSpace.View.BarBtnItemTitleBgLayerBottomColor
        btn.addSubview(bgLayer)
        bgLayer.layer.zPosition = 0
        btn.titleEdgeInsets = UIEdgeInsetsMake(67.0 , 0.0, 0.0, 0.0 )
        btn.titleLabel?.font = UIFont.systemFontOfSize(CGFloat(11.0))
        btn.titleLabel?.layer.zPosition = 1
        btn.setTitle("Natual", forState: UIControlState.Normal)
        btn.setBackgroundImage(btnimg, forState: UIControlState.Normal)
        btn.addTarget(parentView, action: handler, forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }
    // Classify by category, i.e. Beauty, Filter ...
//    class func tapBtn (btnType: BtnType, tabType: Category, parentView: UIViewController, handler: Selector) -> UIBarButtonItem {
//        var tabBtn: UIBarButtonItem!
//        
//        if (btnType == BtnType.Plain){
//            switch tabType {
//            case Category.Beauty:
//                tabBtn = UIBarButtonItem(title: Category.Beauty.simpleDesp(), style: .Plain, target: parentView, action: handler)
//                break
//            default:
//                tabBtn = UIBarButtonItem(title: "Unkown", style: .Plain, target: parentView, action: handler)
//            }
//        } else if (btnType == BtnType.Img) {
//            // TODO
//        }
//        
//        return tabBtn
//    }
    
}

class ScrollableBottomToolbar {
    class func insertScrollableBottomToolbar (parentView: UIViewController, btnArray: [UIBarButtonItem])->UIToolbar {
        let bottomToolbar = UIToolbar(frame: CGRect(x: 0, y: parentView.view.frame.height * 0.87, width: parentView.view.frame.width, height: parentView.view.frame.height * 0.13))
        bottomToolbar.bounds = bottomToolbar.frame
        bottomToolbar.barStyle = UIBarStyle.BlackTranslucent
        
        let bottomToolbarScrollView = UIScrollView(frame: bottomToolbar.frame)
        bottomToolbarScrollView.bounds = bottomToolbarScrollView.frame
        bottomToolbarScrollView.autoresizingMask = bottomToolbar.autoresizingMask
        bottomToolbarScrollView.showsHorizontalScrollIndicator = false
        bottomToolbarScrollView.showsHorizontalScrollIndicator = false
        bottomToolbarScrollView.userInteractionEnabled = true
        
        // TODO Bug
        bottomToolbar.frame = CGRect(x:0, y:0, width: parentView.view.frame.width/4 * CGFloat(btnArray.count + 1), height: bottomToolbar.frame.height)
        bottomToolbar.bounds = bottomToolbar.frame
        bottomToolbar.autoresizingMask = UIViewAutoresizing.None
        bottomToolbar.userInteractionEnabled = true
        bottomToolbar.setItems(btnArray, animated: true)
        
        bottomToolbarScrollView.contentSize = bottomToolbar.frame.size
        bottomToolbarScrollView.addSubview(bottomToolbar)
        parentView.view.addSubview(bottomToolbarScrollView)
        
        return bottomToolbar
    }
}
