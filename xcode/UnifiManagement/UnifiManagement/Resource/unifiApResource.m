//
//  unifiApResource.m
//  UnifiManagement
//
//  Created by Boshido on 11/20/56 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import "unifiApResource.h"

@implementation unifiApResource

+(void)getApCount:(ApiCallbackComplete)callback{
    
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/ap-count",ApiServerAddress] andCallback:callback];
    [object loadGetData];
}


@end