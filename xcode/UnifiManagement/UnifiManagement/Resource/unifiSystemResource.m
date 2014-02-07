//
//  unifiSystemResource.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 12/3/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import "unifiSystemResource.h"

@implementation unifiSystemResource
+(void)getTrafficReport:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromStartTime:(NSTimeInterval )time andType:(NSString *)type{
    unifiApiConnector *object = [[unifiApiConnector alloc]
        initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/traffic-report?time=%f&type=%@",ApiServerAddress,time,type]
        withCompleteCallback:completeCallback withErrorCallback:errorCallback
    ];
    
    [object loadGetData];
}
+(void)getTrafficUserReport:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromStartTime:(NSTimeInterval )time andType:(NSString *)type{
    unifiApiConnector *object = [[unifiApiConnector alloc]
        initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/traffic-user-report?time=%f&type=%@",ApiServerAddress,time,type]
        withCompleteCallback:completeCallback withErrorCallback:errorCallback
    ];
 
    [object loadGetData];
}
+(void)testConection:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback{
    unifiApiConnector *object = [[unifiApiConnector alloc]
                                 initWithUrl:[NSString stringWithFormat:@"http://%@/unifi",ApiServerAddress]
                                 withCompleteCallback:completeCallback withErrorCallback:errorCallback
                                 ];
    [object loadGetData];
}
@end
