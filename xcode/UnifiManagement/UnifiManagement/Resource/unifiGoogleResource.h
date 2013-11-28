//
//  unifiGoogleResource.h
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 11/28/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "unifiApiConnector.h"

@interface unifiGoogleResource : NSObject
    +(void)getUserData:(ApiCallbackComplete)callback withRefreshToken:(NSString *)refreshToken;
@end
