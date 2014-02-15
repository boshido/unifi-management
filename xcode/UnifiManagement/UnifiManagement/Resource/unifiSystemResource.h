//
//  unifiSystemResource.h
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 12/3/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "unifiApiConnector.h"

@interface unifiSystemResource : NSObject
+(void)getTrafficReport:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromStartTime:(NSTimeInterval )time andType:(NSString *)type;
+(void)getTrafficUserReport:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromStartTime:(NSTimeInterval )time andType:(NSString *)type;
+(void)getMapList:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback;
+(void)getMapApList:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromMapId:(NSString *)id;
+(void)getSettingsInformation:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromTokenId:(NSString *)tokenId;
+(void)getAlarm:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback withType:(bool)type fromStart:(NSInteger)start toLength:(NSInteger)length ;
+(void)setUserGroup:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromId:(NSString *)id withName:(NSString *)name andDownload:(NSInteger)download andUpload:(NSInteger)upload;
+(void)setIosToken:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromTokenId:(NSString *)tokenId isEnabled:(NSString *) flag;
+(void)setLoadBalancing:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback withMaxUser:(NSInteger)maxUser isEnabled:(NSString *)flag;
+(void)testConection:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback;
@end
