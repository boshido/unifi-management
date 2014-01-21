//
//  unifiDeviceResource.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 1/2/2557 BE.
//  Copyright (c) 2557 KMUTNB. All rights reserved.
//

#import "unifiDeviceResource.h"

@implementation unifiDeviceResource

// GET
+(void)getDeviceCount:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback{
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/device-count",ApiServerAddress] withCompleteCallback:completeCallback withErrorCallback:errorCallback];
    [object loadGetData];
}
+(void)getOnlineDeviceList:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromStart:(NSInteger)start toLength:(NSInteger)length{
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/online-device-list?start=%i&length=%i",ApiServerAddress,start,length] withCompleteCallback:completeCallback withErrorCallback:errorCallback];
    [object loadGetData];
}
+(void)getOfflineDeviceList:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromStart:(NSInteger)start toLength:(NSInteger)length{
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/offline-device-list?start=%i&length=%i",ApiServerAddress,start,length] withCompleteCallback:completeCallback withErrorCallback:errorCallback];
    [object loadGetData];
}
+(void)getPendingDeviceList:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromStart:(NSInteger)start toLength:(NSInteger)length{
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/pending-device-list?start=%i&length=%i",ApiServerAddress,start,length] withCompleteCallback:completeCallback withErrorCallback:errorCallback];
    [object loadGetData];
}
+(void)getUnAuthorizedDeviceList:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromStart:(NSInteger)start toLength:(NSInteger)length{
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/unauthorized-device-list?start=%i&length=%i",ApiServerAddress,start,length] withCompleteCallback:completeCallback withErrorCallback:errorCallback];
    [object loadGetData];
}
+(void)getAuthorizedDevice:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromGoogleId:(NSString *)googleId{
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/authorized-device?google_id=%@",ApiServerAddress,googleId] withCompleteCallback:completeCallback withErrorCallback:errorCallback];
    [object loadGetData];
}
+(void)getDevice:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromMac:(NSString *)mac{
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/device?mac=%@",ApiServerAddress,mac] withCompleteCallback:completeCallback withErrorCallback:errorCallback];
    [object loadGetData];
}
+(void)getDeviceDailyStatistic:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromStartTime:(NSTimeInterval )starttime fromEndTime:(NSTimeInterval )endtime  withMac:(NSString *)mac{
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/stat-daily?mac=%@&at=%f&to=%f",ApiServerAddress,mac,starttime,endtime] withCompleteCallback:completeCallback withErrorCallback:errorCallback];
    [object loadGetData];
}


// Post
+(void)authorizeDevice:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromGoogleId:(NSString *)googleId andHostname:(NSString *)hostname  andMac:(NSString *)mac andFirstName:(NSString *)firstName andLastName:(NSString *)lastName andEmail:(NSString *)email{

    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/authorize",ApiServerAddress] withCompleteCallback:completeCallback withErrorCallback:errorCallback andData:[NSString stringWithFormat:@"google-id=%@&device-name=%@&device-mac=%@&google-fname=%@&google-lname=%@&google-email=%@",googleId,hostname,mac,firstName,lastName,email]];
    [object loadPostData];
}
+(void)unAuthorizeDevice:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromMac:(NSString *)mac{
    
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/deactive-session",ApiServerAddress] withCompleteCallback:completeCallback withErrorCallback:errorCallback andData:[NSString stringWithFormat:@"mac=%@",mac]];
    [object loadPostData];
}
+(void)blockDevice:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromMac:(NSString *)mac{
    
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/block",ApiServerAddress] withCompleteCallback:completeCallback withErrorCallback:errorCallback andData:[NSString stringWithFormat:@"mac=%@",mac]];
    [object loadPostData];
}
+(void)unBlockDevice:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromMac:(NSString *)mac{
    
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/un-block",ApiServerAddress] withCompleteCallback:completeCallback withErrorCallback:errorCallback andData:[NSString stringWithFormat:@"mac=%@",mac]];
    [object loadPostData];
}
@end
