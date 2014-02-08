//
//  unifiGoogleResource.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 11/28/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import "unifiGoogleResource.h"
#import "unifiGlobalVariable.h"

@implementation unifiGoogleResource
+(void)getAccessToken:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromRefreshToken:(NSString *)refreshToken
{
    
    NSString *clientId = @"422391959017-g7pjv4dcgfqrahuad57nftm3s7jkct40.apps.googleusercontent.com";
    NSString *clientSecret = @"NfkcgQKYWoczllzdZXr7VSSj";
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:@"https://accounts.google.com/o/oauth2/token"
    withCompleteCallback:completeCallback withErrorCallback:errorCallback
    andData:[NSString stringWithFormat:@"client_id=%@&client_secret=%@&refresh_token=%@&grant_type=refresh_token",
             clientId,clientSecret,refreshToken]];
    
    [object loadPostData];
    //http://202.44.47.47/fitmmon/v3/webui/apiv2/loginAPI.php?email=
    //{code: data:{gname:}}
}

+(void)getUserData:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromRefreshToken:(NSString *)refreshToken{
    
    ApiCompleteCallback getAccessToken = ^(NSJSONSerialization *responseJSON,NSString *responseNSString){
        unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"https://www.googleapis.com/oauth2/v1/userinfo?access_token=%@",[responseJSON valueForKey:@"access_token"]] withCompleteCallback:completeCallback withErrorCallback:errorCallback];
        [object loadGetData];
    };
    [ self getAccessToken:getAccessToken withHandleError:errorCallback fromRefreshToken:refreshToken];

}
+(void)getUserData:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromGoogleId:(NSString *)id{
    
    unifiApiConnector *object = [[unifiApiConnector alloc]
                                 initWithUrl:[NSString stringWithFormat:@"http://%@/unifi/google-account?google_id=%@",ApiServerAddress,id]
                                 withCompleteCallback:completeCallback withErrorCallback:errorCallback
                                 ];
    [object loadGetData];
    
}

+(void)getPermission:(ApiCompleteCallback)completeCallback withHandleError:(ApiErrorCallback)errorCallback fromEmail:(NSString *)email
{
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:@"http://202.44.47.47/fitmmon/v3/webui/apiv2/loginAPI.php"
                                                  withCompleteCallback:completeCallback withErrorCallback:errorCallback
                                                               andData:[NSString stringWithFormat:@"email=%@",
                                                                        email]];
    
    [object loadPostData];
}
+(void)isNeedForLogin:(void(^)(void))callback{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"refresh_token.plist"];
    
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *refreshToken = [plistDict objectForKey:@"refreshToken"];
    
    if (![refreshToken isEqualToString:@""] && refreshToken != NULL) {
        [unifiGoogleResource
         getUserData:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
             [unifiGlobalVariable sharedGlobalData].name = [responseJSON valueForKey:@"given_name"];
             [unifiGlobalVariable sharedGlobalData].surname = [responseJSON valueForKey:@"family_name"];
             [unifiGlobalVariable sharedGlobalData].email = [responseJSON valueForKey:@"email"];
             [unifiGlobalVariable sharedGlobalData].profilePicture = [responseJSON valueForKey:@"picture"];
             
             [unifiGoogleResource
              getPermission:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
                  if([[responseJSON valueForKey:@"code"] intValue]==200){
                      [unifiGlobalVariable sharedGlobalData].refreshToken = refreshToken;
                      [unifiGlobalVariable sharedGlobalData].permissionNumber = [[[responseJSON valueForKey:@"data"] valueForKey:@"gaccess"] intValue];
                      [unifiGlobalVariable sharedGlobalData].permissionName = [[responseJSON valueForKey:@"data"] valueForKey:@"gname"];
                      
                      NSLog(@"%@",@{
                                    @"refreshToken":[unifiGlobalVariable sharedGlobalData].refreshToken,
                                    @"permissonNumber":[NSNumber numberWithInt:[unifiGlobalVariable sharedGlobalData].permissionNumber],
                                    @"permissionName":[unifiGlobalVariable sharedGlobalData].permissionName
                                    });
                      
                      
                      NSString *error = [NSString stringWithFormat:@"Can not save refresh token to plist."];
                      NSData *plistData = [NSPropertyListSerialization
                                           dataFromPropertyList:@{
                                                                  @"refreshToken":[unifiGlobalVariable sharedGlobalData].refreshToken,
                                                                  @"permissonNumber":[NSNumber numberWithInt:[unifiGlobalVariable sharedGlobalData].permissionNumber],
                                                                  @"permissionName":[unifiGlobalVariable sharedGlobalData].permissionName
                                                                  }
                                           format:NSPropertyListXMLFormat_v1_0
                                           errorDescription:&error
                                           ];
                      if(plistData) {
                          [plistData writeToFile:plistPath atomically:YES];
                      }
                      else {
                          NSLog(@"Error : %@",error);
                      }
                  }
                  else{
                      [unifiGlobalVariable initialValue];
                      callback();
                  }
              }
              withHandleError:^(NSError *error) {
                  [unifiGlobalVariable initialValue];
              }
              fromEmail:[responseJSON valueForKey:@"email"]
              ];
         }
         withHandleError:^(NSError *error) {
             [unifiGlobalVariable initialValue];
         }
         fromRefreshToken:refreshToken
         ];
    }
    else{
        [unifiGlobalVariable initialValue];
        callback();
    }
}
@end
