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

struct facePoint{
    int x;
    int y;
};
+(void) uploadImage:(UIImage *)image {
    
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
 //   [request setValue:parameters forHTTPHeaderField:@"parameters"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"Success:***** %@",  result);
 //       NSDictionary *jsonDict = (NSDictionary *)result;
   
        NSString *pitch = [[[result valueForKey:@"attributes"]valueForKey:@"headPose"]valueForKey:@"pitch"];
        NSString *roll = [[[result valueForKey:@"attributes"]valueForKey:@"headPose"]valueForKey:@"roll"];
 //       double pi = [pitch doubleValue];
//        
//        [pitch floatValue];
//        float ro = [roll floatValue];
//        int yaw = [[[[result valueForKey:@"attributes"]valueForKey:@"headPose"]valueForKey:@"yaw"] intValue];
//
//        int x = [[[[result valueForKey:@"faceLandmarks"]valueForKey:@"eyeLeftOuter"]valueForKey:@"x"] intValue];
//        int y = [[[[result valueForKey:@"faceLandmarks"]valueForKey:@"eyeLeftOuter"]valueForKey:@"y"] intValue];
//        struct facePoint eyeLeftOuter, eyeRightOuter;
//        eyeLeftOuter.x = x;
//        eyeLeftOuter.y = y;
//        x = [[[[result valueForKey:@"faceLandmarks"]valueForKey:@"eyeRightOuter"]valueForKey:@"x"] intValue];
//        y = [[[[result valueForKey:@"faceLandmarks"]valueForKey:@"eyeRightOuter"]valueForKey:@"y"] intValue];
//        eyeRightOuter.x = x;
//        eyeRightOuter.y = y;
        
//        NSLog(@"%f", pi);
//        NSLog(@"%f", ro);
//        NSLog(@"%d", yaw);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
    }];
    [operation start];
}

+ (void) postRequestUploadImage: (UIImage*) image {
    
    NSDictionary *parameters = @{
                                 @"entities": @true,
                                 @"analyzesFaceLandmarks":@true,
                                 @"analyzesAge":@false,
                                 @"analyzesGender": @true,
                                 @"analyzesHeadPose": @true
                                 };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:OxfordKey forHTTPHeaderField:@"Ocp-Apim-Subscription-Key"];
    [manager.requestSerializer setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    
    [manager POST:@"https://api.projectoxford.ai/face/v0/detections?" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        UIImage *postimage = image;
        NSData *data = UIImageJPEGRepresentation(postimage, 0.5); //压缩处理
        [formData appendPartWithFileData:data name:@"image" fileName:@"test.jpg" mimeType:@"image/jpeg"];
        
    }
    success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);

    }];
}

@end