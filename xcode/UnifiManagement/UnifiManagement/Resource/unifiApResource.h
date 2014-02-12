//
//  unifiApResource.h
//  UnifiManagement
//
//  Created by Boshido on 11/20/56 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "unifiApiConnector.h"

@interface unifiApResource : NSObject/*: unifiApiConnector*/
+(void)getAp:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromMac:(NSString *)mac;
+(void)getDevice:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromApMac:(NSString *)mac;
+(void)getApCount:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback;
+(void)getApMapCount:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback;
+(void)setApName:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback withName:(NSString *)name fromId:(NSString *)id;
+(void)restartAp:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromMac:(NSString *)mac;
@end
