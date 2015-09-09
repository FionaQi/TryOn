//
//  faceAPI.m
//  TryOn
//
//  Created by QiFeng on 7/28/15.
//  Copyright © 2015 QiFeng. All rights reserved.
//

#import "faceAPI.h"
#import <Foundation/Foundation.h>

@implementation faceAPI

static NSString *OxfordKey = @"";


+(faceLandmarks*) uploadImage:(UIImage *)image {
    faceLandmarks *landmarks = [[faceLandmarks alloc] init];
    [landmarks initfaceLandmarks];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    NSString* path = @"https://api.projectoxford.ai/face/v0/detections";
    NSArray* array = @[@"entities=true",
                       @"analyzesFaceLandmarks=true",
                       @"analyzesAge=false",
                       @"analyzesGender=false",
                       @"analyzesHeadPose=true",
                       ];
    
    NSString* string = [array componentsJoinedByString:@"&"];
    path = [path stringByAppendingFormat:@"?%@", string];
    
    NSURL *url = [NSURL URLWithString:path ];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:imageData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    [request setValue:OxfordKey forHTTPHeaderField:@"Ocp-Apim-Subscription-Key"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id result) {
  //      NSLog(@"Success:***** %@",  result[0]);
        
        NSString *s_pitch = [[[result[0] valueForKey:@"attributes"]valueForKey:@"headPose"]valueForKey:@"pitch"];
        NSString *s_roll = [[[result[0] valueForKey:@"attributes"]valueForKey:@"headPose"]valueForKey:@"roll"];
        NSString *s_yaw = [[[result[0] valueForKey:@"attributes"]valueForKey:@"headPose"]valueForKey:@"yaw"];
        
        landmarks.pitch = [s_pitch floatValue];
        landmarks.roll = [s_roll floatValue];
        landmarks.yaw = [s_yaw floatValue];
        int x = [[[[result[0] valueForKey:@"faceLandmarks"]valueForKey:@"eyeLeftOuter"]valueForKey:@"x"] intValue];
        int y = [[[[result[0] valueForKey:@"faceLandmarks"]valueForKey:@"eyeLeftOuter"]valueForKey:@"y"] intValue];
        landmarks.leftEyeOuter = CGPointMake(CGFloat(x), CGFloat(y));
        int x2 = [[[[result[0] valueForKey:@"faceLandmarks"]valueForKey:@"eyeRightOuter"]valueForKey:@"x"] intValue];
        int y2 = [[[[result[0] valueForKey:@"faceLandmarks"]valueForKey:@"eyeRightOuter"]valueForKey:@"y"] intValue];
        landmarks.rightEyeOuter = CGPointMake(CGFloat(x2), CGFloat(y2));
        NSLog(@"pitch= %f", landmarks.pitch);
        NSLog(@"roll= %f", landmarks.roll);
        NSLog(@"yaw= %f", landmarks.yaw);
        NSLog(@"left eye outer x: %d y: %d", x, y);
        NSLog(@"right eye outer x: %d y: %d", x2, y2);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
    }];
    [operation start];
    return landmarks;
}

@end