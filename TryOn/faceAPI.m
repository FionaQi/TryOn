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
//+ (void) postRequestUploadImage: (UIImage*) image {
//    
//    NSDictionary *parameters = @{
//                                 @"entities": @true,
//                                 @"analyzesFaceLandmarks":@true,
//                                 @"analyzesAge":@false,
//                                 @"analyzesGender": @true,
//                                 @"analyzesHeadPose": @true};
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    [manager.requestSerializer setValue:OxfordKey forHTTPHeaderField:@"Ocp-Apim-Subscription-Key"];
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/json"];
// //   manager.requestSerializer
//    //    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
//    //    [requestSerializer setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-type"];
//    //  manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
//    
//    [manager POST:@"https://api.projectoxford.ai/face/v0/detections?" parameters:parameters constructingBodyWithBlock:nil
//     //     ^(id<AFMultiparformData) {
//     //
//     //        UIImage *postimage = image;
//     //        NSData *data = UIImageJPEGRepresentation(postimage, 0.5); //压缩处理
//     //
//     //        [formData appendPartWithInputStream:data name:"image" fileName:@"test.jpg" length:sizeof(data) mimeType:@"application/octet-stream"];
//     //        [formData appendPartWithFileData:data name:@"image" fileName:@"test.jpg" mimeType:@"application/octet-stream"];
//     
//     
//     //        NSURL *filepath = [NSURL fileURLWithPath:@"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRs7P15xlx78p_gaiuK5VnsSIFV7HkmYcCjiICDR4id2-HUEhtt"];
//     //        [formData appendPartWithFileURL:filepath name:@"image" fileName:@"imageq" mimeType:@"application/json" error:nil];
//     
//     //    }
//          success:^(AFHTTPRequestOperation *operation, id responseObject) {
//              NSLog(@"JSON: %@", responseObject);
//          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//              NSLog(@"Error: %@", error);
//              
//          }];
//}
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
   //     NSData *data = UIImageJPEGRepresentation(postimage, 0.5); //压缩处理
  //      NSInputStream *stream = [[NSInputStream alloc] initWithData:data];
//        [formData appendPartWithInputStream:stream name:@"image" fileName:@"test" length:sizeof(stream) mimeType:@"application/octet-stream"];
//        [formData appendPartWithFileData:data name:@"image" fileName:@"test.jpg" mimeType:@"image/jpeg"];
        
        
        NSURL *filepath = [NSURL fileURLWithPath:@"http://www.globalcool.org/wp-content/uploads/2012/08/PA-12222013-1024x802.jpg"];
        [formData appendPartWithFileURL:filepath name:@"image" fileName:@"imageq" mimeType:@"application/json" error:nil];
        
    }
    success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);

    }];
}

+ (void)request{
    @autoreleasepool {
        NSString* path = @"https://api.projectoxford.ai/face/v0/detections";
        NSArray* array = @[
                           // Request parameters
                           @"analyzesFaceLandmarks=false",
                           @"analyzesAge=false",
                           @"analyzesGender=false",
                           @"analyzesHeadPose=false",
                           @"Ocp-Apim-Subscription-Key=4a61f11144f04d908a0275ce5885469d"
                           ];
        
        NSString* string = [array componentsJoinedByString:@"&"];
        path = [path stringByAppendingFormat:@"?%@", string];
        
        NSLog(@"%@", path);
        
        NSMutableURLRequest* _request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:path]];
        [_request setHTTPMethod:@"POST"];
        // Request headers
        [_request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        //[_request setValue:@"{4a61f11144f04d908a0275ce5885469d}" forHTTPHeaderField:@"Ocp-Apim-Subscription-Key"];
        // Request body
        [_request setHTTPBody:[@"{url: \"http://www.globalcool.org/wp-content/uploads/2012/08/PA-12222013-1024x802.jpg\"}" dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData* _connectionData = [NSURLConnection sendSynchronousRequest:_request returningResponse:&response error:&error];
        
        if (nil != error)
        {
            NSLog(@"Error: %@", error);
        }
        else
        {
            NSError* error = nil;
            NSMutableDictionary* json = nil;
            NSString* dataString = [[NSString alloc] initWithData:_connectionData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", dataString);
            
            if (nil != _connectionData)
            {
                json = [NSJSONSerialization JSONObjectWithData:_connectionData options:NSJSONReadingMutableContainers error:&error];
            }
            
            if (error || !json)
            {
                NSLog(@"Could not parse loaded json with error:%@", error);
            }
            
            NSLog(@"%@", json);
            _connectionData = nil;
        }

    }
    
}

@end