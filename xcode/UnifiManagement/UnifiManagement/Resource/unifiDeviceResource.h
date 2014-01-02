//
//  unifiDeviceResource.h
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 1/2/2557 BE.
//  Copyright (c) 2557 KMUTNB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "unifiApiConnector.h"

@interface unifiDeviceResource : NSObject
+(void)getDeviceCount:(ApiCallbackComplete)callback;
+(void)getAuthorizedDevice:(ApiCallbackComplete)callback withGoogleId:(NSString *)googleId;
@end
