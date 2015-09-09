//
//  Animation.swift
//  TryOn
//
//  Created by QiFeng on 9/9/15.
//  Copyright © 2015 QiFeng. All rights reserved.
//

import Foundation

class Animation {

    class func vanishOrAppear(target: UIView, time: CFTimeInterval, from: CGFloat, to: CGFloat) {
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = from
        animation.toValue = to
        animation.duration = CFTimeInterval(time)
        target.layer.addAnimation(animation, forKey: "Image-opacity")
        target.alpha = 0
    }
}