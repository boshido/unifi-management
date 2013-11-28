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
@synthesize count,accessToken,refreshToken;

+(unifiGlobalVariable *)sharedGlobalData{
    if(sharedGlobalData == nil){
        sharedGlobalData = [[super allocWithZone:NULL] init];
        // initial value
        sharedGlobalData.count=0;
        sharedGlobalData.accessToken=@"";
        sharedGlobalData.refreshToken=@"";
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
@end
