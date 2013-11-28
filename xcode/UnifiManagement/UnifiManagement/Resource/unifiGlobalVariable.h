//
//  unifiGlobalVariable.h
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 11/26/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface unifiGlobalVariable : NSObject
@property NSInteger count;
@property(retain,nonatomic) NSString *accessToken;
@property(retain,nonatomic) NSString *refreshToken;
+(unifiGlobalVariable *)sharedGlobalData;

@end
