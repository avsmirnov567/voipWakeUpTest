//
//  VTNetworkManager.m
//  voiptestlineapp
//
//  Created by Aleksandr Smirnov on 07.03.17.
//  Copyright © 2017 Line App. All rights reserved.
//

#import "VTNetworkManager.h"
#import "AFNetworking.h"

@implementation VTNetworkManager

+(void)sendLocation:(NSString *)location
            success:(void (^)(NSString *))success
            failure:(BOOL (^)(NSError *))failure
{
    NSDictionary *body = @{@"location":location};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"https://still-coast-32947.herokuapp.com/location" parameters:nil error:nil];
    
    req.timeoutInterval = 30.0f;
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                success([responseObject[@"response"] string]);
            }
        } else {
            NSLog(@"Error!"); 
        }
    }] resume];
}

@end
