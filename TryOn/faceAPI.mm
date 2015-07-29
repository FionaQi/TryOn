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

static NSString *OxfordKey = @"4a61f11144f04d908a0275ce5885469d";


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
    
//    NSLog(@"%@", path);
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
        NSLog(@"Success:***** %@",  result);
        NSDictionary *JSON = (NSDictionary *)result;
    
        NSString *s_pitch = [[[JSON valueForKey:@"attributes"]valueForKey:@"headPose"]valueForKey:@"pitch"];
        NSString *s_roll = [[[JSON valueForKey:@"attributes"]valueForKey:@"headPose"]valueForKey:@"roll"];
        NSString *s_yaw = [[[result valueForKey:@"attributes"]valueForKey:@"headPose"]valueForKey:@"yaw"];

        NSLog(@"%@", s_pitch);
        NSString *string = @"3.2";
        CGFloat pi = [string floatValue];
        NSLog(@"%f", pi);
        //        NSLog(@"%f", ro);
        //        NSLog(@"%d", yaw);
        
//        landmarks.pitch = [s_pitch floatValue];
//        landmarks.roll = [s_roll floatValue];
//        landmarks.yaw = [s_yaw floatValue];
//        landmarks.leftEyeOuter = [self GetPointFromRequest:JSON :@"eyeLeftOuter"];
//        landmarks.rightEyeOuter = [self GetPointFromRequest:JSON :@"eyeRightOuter"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
    }];
    [operation start];
    return landmarks;
}

+(CGPoint)GetPointFromRequest: (NSDictionary*) JSONdic : andKey: (NSString *) Keyvalue {
    NSString *x_Str = [[[JSONdic valueForKey:@"faceLandmarks"]valueForKey:Keyvalue]valueForKey:@"x"];
    NSString *y_Str = [[[JSONdic valueForKey:@"faceLandmarks"]valueForKey:Keyvalue]valueForKey:@"y"];
    char fnameStr[10];
 //   fnameStr =[x_Str UTF8String];
    float x = [x_Str floatValue];
    CGPoint rect;
    return rect;
}
@end