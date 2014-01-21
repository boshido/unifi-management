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
+(void)getPendingDeviceList:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromStart:(NSInteger)start toLength:(NSInteger)length;
+(void)getUnAuthorizedDeviceList:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromStart:(NSInteger)start toLength:(NSInteger)length;
+(void)getAuthorizedDevice:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromGoogleId:(NSString *)googleId;
+(void)getDevice:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromMac:(NSString *)mac;
+(void)getDeviceDailyStatistic:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromStartTime:(NSTimeInterval )starttime fromEndTime:(NSTimeInterval )endtime  withMac:(NSString *)mac;

+(void)authorizeDevice:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromGoogleId:(NSString *)googleId andHostname:(NSString *)hostname  andMac:(NSString *)mac andFirstName:(NSString *)firstName andLastName:(NSString *)lastName andEmail:(NSString *)email;
+(void)unAuthorizeDevice:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromMac:(NSString *)mac;
+(void)blockDevice:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromMac:(NSString *)mac;
+(void)unBlockDevice:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromMac:(NSString *)mac;
@end
