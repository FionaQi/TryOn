//
//  animBackground.swift
//  TryOn
//
//  Created by QiFeng on 7/30/15.
//  Copyright © 2015 QiFeng. All rights reserved.
//

import Foundation
import UIKit
class animBackground {
    class func addFloatingView (processingView: EditPageViewController) {
        let rectHud : CGRect = CGRectMake(0, 0, processingView.view.frame.width,processingView.view.frame.height)
        processingView.savedFloatingView = UIView(frame: rectHud)
        processingView.savedFloatingView.backgroundColor = ColorSpace.View.backgroundColor
        processingView.view.addSubview(processingView.savedFloatingView)
    }
    
    class func removeFloatingView (processingView: EditPageViewController) {
        processingView.savedFloatingView.removeFromSuperview()
    }
}