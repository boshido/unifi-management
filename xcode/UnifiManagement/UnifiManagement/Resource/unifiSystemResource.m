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
+(void)getSettingsInformation:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromTokenId:(NSString *)tokenId{
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/settings-information?token_id=%@",ApiServerAddress,tokenId] withCompleteCallback:completeCallback withErrorCallback:errorCallback];
    [object loadGetData];
}
+(void)getAlarm:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback withType:(bool)type fromStart:(NSInteger)start toLength:(NSInteger)length {
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/alarm?type=%@&start=%i&length=%i",ApiServerAddress,type ? @"true" : @"false",start,length] withCompleteCallback:completeCallback withErrorCallback:errorCallback];
    [object loadGetData];
}
+(void)setIosToken:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromTokenId:(NSString *)tokenId isEnabled:(NSString *) flag{
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/ios-token",ApiServerAddress ] withCompleteCallback:completeCallback withErrorCallback:errorCallback andData:[NSString stringWithFormat:@"token_id=%@&enabled=%@",tokenId,flag != nil ? flag : @""]];
    
    [object loadPostData];
}
+(void)setUserGroup:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromId:(NSString *)id withName:(NSString *)name andDownload:(NSInteger)download andUpload:(NSInteger)upload {
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/usergroup",ApiServerAddress ] withCompleteCallback:completeCallback withErrorCallback:errorCallback andData:[NSString stringWithFormat:@"id=%@&name=%@&qos_rate_max_down=%i&qos_rate_max_up=%i",id,name,download,upload]];
    
    [object loadPostData];
}
+(void)setLoadBalancing:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback withMaxUser:(NSInteger)maxUser isEnabled:(NSString *)flag {
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/load-balancing",ApiServerAddress ] withCompleteCallback:completeCallback withErrorCallback:errorCallback andData:[NSString stringWithFormat:@"max_sta=%i&enabled=%@",maxUser,flag ]];
    
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
