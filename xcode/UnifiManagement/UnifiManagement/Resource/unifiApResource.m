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
    
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:@"http://202.44.47.47/unifi/ap-count" andCallback:callback];
    [object loadGetData];
}


@end