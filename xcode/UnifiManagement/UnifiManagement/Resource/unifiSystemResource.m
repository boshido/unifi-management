//
//  unifiSystemResource.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 12/3/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import "unifiSystemResource.h"

@implementation unifiSystemResource
+(void)getTrafficReport:(ApiCallbackComplete)callback withType:(NSString *)type{
    unifiApiConnector *object = [[unifiApiConnector alloc]
        initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/traffic-report?type=%@",ApiServerAddress,type]
        andCallback:callback
    ];
    
    [object loadGetData];
}
+(void)getDeviceReport:(ApiCallbackComplete)callback withType:(NSString *)type{
    unifiApiConnector *object = [[unifiApiConnector alloc]
        initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/device-report?type=%@",ApiServerAddress,type]
        andCallback:callback
    ];
    [object loadGetData];
}
@end
