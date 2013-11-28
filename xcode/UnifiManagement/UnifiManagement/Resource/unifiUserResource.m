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
    
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:@"http://202.44.47.47/unifi/device-count" andCallback:callback];
    [object loadGetData];
    
}
@end
