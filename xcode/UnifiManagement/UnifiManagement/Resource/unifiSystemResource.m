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
+(void)getMapList:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback{
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/map-list",ApiServerAddress] withCompleteCallback:completeCallback withErrorCallback:errorCallback];
    [object loadGetData];
}
+(void)getMapApList:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromMapId:(NSString *)id{
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/map-ap-list?id=%@",ApiServerAddress,id] withCompleteCallback:completeCallback withErrorCallback:errorCallback];
    [object loadGetData];
}
+(void)getAlarm:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback withType:(bool)type fromStart:(NSInteger)start toLength:(NSInteger)length {
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/alarm?type=%@&start=%i&length=%i",ApiServerAddress,type ? @"true" : @"false",start,length] withCompleteCallback:completeCallback withErrorCallback:errorCallback];
    [object loadGetData];
}
+(void)setIosToken:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromTokenId:(NSString *)tokenId isEnabled:(BOOL)flag{
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/ios-token",ApiServerAddress ] withCompleteCallback:completeCallback withErrorCallback:errorCallback andData:[NSString stringWithFormat:@"token_id=%@&enabled=%@",tokenId,flag ? @"true" : @"false"]];
    
    [object loadPostData];
}
+(void)testConection:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback{
    unifiApiConnector *object = [[unifiApiConnector alloc]
                                 initWithUrl:[NSString stringWithFormat:@"http://%@/unifi",ApiServerAddress]
                                 withCompleteCallback:completeCallback withErrorCallback:errorCallback
                                 ];
    [object loadGetData];
}
@end
