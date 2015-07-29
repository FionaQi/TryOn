//
//  faceLandmarks.h
//  TryOn
//
//  Created by QiFeng on 7/29/15.
//  Copyright © 2015 QiFeng. All rights reserved.
//

#ifndef faceLandmarks_h
#define faceLandmarks_h
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface faceLandmarks : NSObject
{
    CGFloat _pitch;
    CGFloat _roll;
    CGFloat _yaw;
    CGPoint _leftEyeOuter;
    CGPoint _rightEyeOuter;
}
- (void) initfaceLandmarks;

@property CGFloat pitch;
@property CGFloat roll;
@property CGFloat yaw;

@property CGPoint leftEyeOuter;
@property CGPoint rightEyeOuter;

@end
#endif /* faceLandmarks_h */
