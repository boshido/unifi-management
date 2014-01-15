//
//  unifiApResource.h
//  UnifiManagement
//
//  Created by Boshido on 11/20/56 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "unifiApiConnector.h"

@interface unifiApResource : NSObject/*: unifiApiConnector*/

+(void)getApCount:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback;
+(void)getApMapCount:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback;
@end
