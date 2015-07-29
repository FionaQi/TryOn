//
//  faceLandmarks.m
//  TryOn
//
//  Created by QiFeng on 7/29/15.
//  Copyright © 2015 QiFeng. All rights reserved.
//


#include "faceLandmarks.h"
@implementation faceLandmarks

@synthesize pitch = _pitch;
@synthesize roll = _roll;
@synthesize yaw = _yaw;
@synthesize leftEyeOuter = _leftEyeOuter;
@synthesize rightEyeOuter = _rightEyeOuter;

- (void) initfaceLandmarks {
    _pitch = 0.0;
    _roll = 0.0;
    _yaw = 0.0;
    _leftEyeOuter = CGPointMake(100.0, 300.0);
    _rightEyeOuter = CGPointMake(200.0, 300.0);;
}

@end