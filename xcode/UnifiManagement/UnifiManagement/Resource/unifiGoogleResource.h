//
//  unifiGoogleResource.h
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 11/28/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "unifiApiConnector.h"

@interface unifiGoogleResource : NSObject
+(void)getAccessToken:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromRefreshToken:(NSString *)refreshToken;
+(void)getUserData:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromRefreshToken:(NSString *)refreshToken;
+(void)getUserData:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromGoogleId:(NSString *)id;
+(void)getPermission:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromEmail:(NSString *)email;
+(void)isNeedForLogin:(void(^)(void))needCallback isNotNeedForLogin:(void(^)(void))notNeedCallback;
@end
