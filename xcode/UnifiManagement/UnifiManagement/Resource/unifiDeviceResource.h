//
//  unifiDeviceResource.h
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 1/2/2557 BE.
//  Copyright (c) 2557 KMUTNB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "unifiApiConnector.h"

@interface unifiDeviceResource : NSObject
+(void)getDeviceCount:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback;
+(void)getUnAuthorizedDevice:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback;
+(void)getAuthorizedDevice:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromGoogleId:(NSString *)googleId;

@end
