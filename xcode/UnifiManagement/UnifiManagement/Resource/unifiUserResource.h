//
//  unifiUserResource.h
//  UnifiManagement
//
//  Created by Boshido on 11/21/56 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "unifiApiConnector.h"

@interface unifiUserResource : NSObject
+(void)getUserList:(ApiCallbackComplete)callback;
+(void)getUserCount:(ApiCallbackComplete)callback;
+(void)getUser:(ApiCallbackComplete)callback FromMac:(NSArray *)userArray;
@end
