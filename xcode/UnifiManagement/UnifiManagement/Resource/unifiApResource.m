//
//  unifiApResource.m
//  UnifiManagement
//
//  Created by Boshido on 11/20/56 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import "unifiApResource.h"

@implementation unifiApResource
+(void)getAp:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromMac:(NSString *)mac{
    
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/ap?mac=%@",ApiServerAddress,mac] withCompleteCallback:completeCallback withErrorCallback:errorCallback];
    [object loadGetData];
}
+(void)getDevice:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromApMac:(NSString *)mac{
    
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/ap-device?mac=%@",ApiServerAddress,mac] withCompleteCallback:completeCallback withErrorCallback:errorCallback];
    [object loadGetData];
}

+(void)getApCount:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback{
    
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/ap-count",ApiServerAddress] withCompleteCallback:completeCallback withErrorCallback:errorCallback];
    [object loadGetData];
}

+(void)getApMapCount:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback{
    
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/ap-map-count",ApiServerAddress] withCompleteCallback:completeCallback withErrorCallback:errorCallback];
    [object loadGetData];
}

+(void)setApName:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback withName:(NSString *)name fromId:(NSString *)id
{
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/edit-ap-name",ApiServerAddress]
                                                  withCompleteCallback:completeCallback withErrorCallback:errorCallback
                                                               andData:[NSString stringWithFormat:@"name=%@&id=%@",
                                                                        name,id]];
    
    [object loadPostData];
}

+(void)restartAp:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromMac:(NSString *)mac
{
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/restart-ap",ApiServerAddress]
                                                  withCompleteCallback:completeCallback withErrorCallback:errorCallback
                                                               andData:[NSString stringWithFormat:@"mac=%@",
                                                                        mac]];
    [object loadPostData];
}

@end