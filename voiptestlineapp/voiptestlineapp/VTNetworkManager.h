//
//  VTNetworkManager.h
//  voiptestlineapp
//
//  Created by Aleksandr Smirnov on 07.03.17.
//  Copyright © 2017 Line App. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VTNetworkManager : NSObject

+ (void)sendLocation:(NSString *)location
             success:(void(^)(NSString *))success
             failure:(BOOL(^)(NSError *))failure;

@end
