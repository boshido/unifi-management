//
//  unifiUserResource.m
//  UnifiManagement
//
//  Created by Boshido on 11/21/56 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import "unifiUserResource.h"

@implementation unifiUserResource

+(void)getUserList:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback{
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/user-list",ApiServerAddress] withCompleteCallback:completeCallback withErrorCallback:errorCallback];
    [object loadGetData];
}
+(void)getUser:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback  fromMac:(NSArray *)userArray{

        NSMutableString *parameter = [NSMutableString stringWithString:@""];
        for(NSString * user in userArray){
            [parameter appendFormat:@"&mac[]=%@",user];
        }
    NSLog(@"%@",parameter);
        unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/user?%@",ApiServerAddress,[parameter substringFromIndex:1]] withCompleteCallback:completeCallback withErrorCallback:errorCallback];
        [object loadGetData];
  
}
@end
