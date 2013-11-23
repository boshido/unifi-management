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

-(void)getApCount:(void (^)(NSJSONSerialization *response))callback;

@end
