//
//  unifiApResource.m
//  UnifiManagement
//
//  Created by Boshido on 11/20/56 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import "unifiApResource.h"

@implementation unifiApResource

+(void)getApCount:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback{
    
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/ap-count",ApiServerAddress] withCompleteCallback:completeCallback withErrorCallback:errorCallback];
    [object loadGetData];
}

+(void)getApMapCount:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback{
    
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/ap-map-count",ApiServerAddress] withCompleteCallback:completeCallback withErrorCallback:errorCallback];
    [object loadGetData];
}

@end