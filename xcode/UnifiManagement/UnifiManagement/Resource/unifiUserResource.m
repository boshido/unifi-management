//
//  unifiUserResource.m
//  UnifiManagement
//
//  Created by Boshido on 11/21/56 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import "unifiUserResource.h"

@implementation unifiUserResource

+(void)getUserCount:(ApiCallbackComplete)callback{
    
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/device-count",ApiServerAddress] andCallback:callback];
    [object loadGetData];
    
}
+(void)getUser:(ApiCallbackComplete)callback FromMac:(NSArray *)userArray{
    if([userArray count]>0){
        NSMutableString *parameter = [NSMutableString stringWithString:@""];
        for(NSString * user in userArray){
            [parameter appendFormat:@"&mac[]=%@",user];
        }
        unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/user?%@",ApiServerAddress,[parameter substringFromIndex:1]] andCallback:callback];
        [object loadGetData];
    }
    else{
        callback(nil,nil);
    }
}
@end
