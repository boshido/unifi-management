//
//  unifiDeviceResource.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 1/2/2557 BE.
//  Copyright (c) 2557 KMUTNB. All rights reserved.
//

#import "unifiDeviceResource.h"

@implementation unifiDeviceResource
+(void)getDeviceCount:(ApiCallbackComplete)callback{
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/device-count",ApiServerAddress] andCallback:callback];
    [object loadGetData];
}
+(void)getAuthorizedDevice:(ApiCallbackComplete)callback withGoogleId:(NSString *)googleId{
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/authorized-device?google_id=%@",ApiServerAddress,googleId] andCallback:callback];
    [object loadGetData];
}
@end
