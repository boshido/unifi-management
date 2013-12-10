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
@end
