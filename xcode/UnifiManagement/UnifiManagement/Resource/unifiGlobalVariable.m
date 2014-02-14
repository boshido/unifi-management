//
//  unifiGlobalVariable.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 11/26/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import "unifiGlobalVariable.h"
@implementation unifiGlobalVariable
static unifiGlobalVariable *sharedGlobalData = nil;
@synthesize name,surname,email,profilePicture,refreshToken,permissionName,permissionNumber,iosToken;

+(unifiGlobalVariable *)sharedGlobalData{
    if(sharedGlobalData == nil){
        sharedGlobalData = [[super allocWithZone:NULL] init];
        // initial value
        [self initialValue];
    }
    return sharedGlobalData;
}
+(id) allocWithZone:(NSZone *)zone{
    @synchronized(self){
        
        if(sharedGlobalData ==nil){
            sharedGlobalData = [super allocWithZone:zone];
            return sharedGlobalData;
        }
    }
    return nil;
}

+(void) initialValue{
    sharedGlobalData.permissionName=@"";
    sharedGlobalData.permissionNumber=-1;
    sharedGlobalData.name=@"";
    sharedGlobalData.surname=@"";
    sharedGlobalData.email=@"";
    sharedGlobalData.profilePicture=@"";
    sharedGlobalData.refreshToken=@"";
    sharedGlobalData.iosToken=@"";
}
@end
