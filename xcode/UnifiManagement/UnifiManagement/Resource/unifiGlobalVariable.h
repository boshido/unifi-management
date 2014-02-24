//
//  unifiGlobalVariable.h
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 11/26/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface unifiGlobalVariable : NSObject
@property(retain,nonatomic) NSString *name;
@property(retain,nonatomic) NSString *surname;
@property(retain,nonatomic) NSString *email;
@property(retain,nonatomic) NSString *profilePicture;
@property(retain,nonatomic) NSString *refreshToken;
@property(retain,nonatomic) NSString *permissionName;
@property(retain,nonatomic) NSString *iosToken;
@property NSInteger permissionNumber;

+(unifiGlobalVariable *)sharedGlobalData;
+(void)initialValue;
+(void)refreshValue;
@end
