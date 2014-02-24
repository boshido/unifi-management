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

+(void)getTopTenTrafficUserReport:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromStartTime:(NSTimeInterval )time andType:(NSString *)type{
    NSLog(@"%@",[NSString stringWithFormat:@"http://%@/unifi/top-ten-user-report?time=%f&type=%@",ApiServerAddress,time,type]);
    unifiApiConnector *object = [[unifiApiConnector alloc]
                                 initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/top-ten-user-report?time=%f&type=%@",ApiServerAddress,time,type]
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
+(void)setNotification:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback withTokenId:(NSString *)tokenId {
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/notification",ApiServerAddress] withCompleteCallback:completeCallback withErrorCallback:errorCallback  andData:[NSString stringWithFormat:@"token_id=%@",tokenId]];
    
    [object loadPostData];
}
+(void)getNotification:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback withTokenId:(NSString *)tokenId {
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/notification?token_id=%@",ApiServerAddress,tokenId] withCompleteCallback:completeCallback withErrorCallback:errorCallback];
    [object loadGetData];
}

+(void)getNotificationList:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromStart:(NSInteger)start toLength:(NSInteger)length withTokenId:(NSString *)tokenId{
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/notification-list?token_id=%@&start=%i&length=%i",ApiServerAddress,tokenId,start,length] withCompleteCallback:completeCallback withErrorCallback:errorCallback];
    [object loadGetData];
}

+(void)setIosToken:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromTokenId:(NSString *)tokenId isEnabled:(NSString *) flag{
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/ios-token",ApiServerAddress ] withCompleteCallback:completeCallback withErrorCallback:errorCallback andData:[NSString stringWithFormat:@"token_id=%@&enabled=%@",tokenId,flag != nil ? flag : @""]];
    
    [object loadPostData];
}
+(void)setGroup:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromId:(NSString *)id withName:(NSString *)name andDownload:(NSInteger)download andUpload:(NSInteger)upload {
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/group",ApiServerAddress ] withCompleteCallback:completeCallback withErrorCallback:errorCallback andData:[NSString stringWithFormat:@"id=%@&name=%@&qos_rate_max_down=%i&qos_rate_max_up=%i",id,name,download,upload]];
    
    [object loadPostData];
}
+(void)deleteGroup:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromId:(NSString *)id {
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/delete-group",ApiServerAddress ] withCompleteCallback:completeCallback withErrorCallback:errorCallback andData:[NSString stringWithFormat:@"id=%@",id]];
    
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




+(void)getDeviceInGroup:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromStart:(NSInteger)start toLength:(NSInteger)length andGroupId:(NSString *)id{
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/device-in-group?start=%i&length=%i&id=%@",ApiServerAddress,start,length,id ] withCompleteCallback:completeCallback withErrorCallback:errorCallback];
    
    [object loadGetData];
}
+(void)getDeviceForAdding:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromStart:(NSInteger)start toLength:(NSInteger)length andGroupId:(NSString *)id{
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/device-for-adding?start=%i&length=%i&id=%@",ApiServerAddress,start,length,id ] withCompleteCallback:completeCallback withErrorCallback:errorCallback];
    
    [object loadGetData];
}
+(void)changeDeviceToGroup:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromGroupId:(NSString *)groupId andUserId:(NSString *)UserId{
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/change-device-to-group",ApiServerAddress ] withCompleteCallback:completeCallback withErrorCallback:errorCallback andData:[NSString stringWithFormat:@"group_id=%@&user_id=%@",groupId,UserId]];
    
    [object loadPostData];
}


+(void)getCurrentUsage:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback{
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/current-usage",ApiServerAddress ] withCompleteCallback:completeCallback withErrorCallback:errorCallback];
    
    [object loadGetData];
}
@end
