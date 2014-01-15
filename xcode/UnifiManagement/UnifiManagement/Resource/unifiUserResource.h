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
+(void)getUserList:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback;
+(void)getUser:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback  fromMac:(NSArray *)userArray;
@end
