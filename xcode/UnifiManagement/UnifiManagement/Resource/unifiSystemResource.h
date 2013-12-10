//
//  unifiSystemResource.h
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 12/3/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "unifiApiConnector.h"

@interface unifiSystemResource : NSObject
+(void)getTrafficReport:(ApiCallbackComplete)callback withType:(NSString *)type;
+(void)getDeviceReport:(ApiCallbackComplete)callback withType:(NSString *)type;
@end
