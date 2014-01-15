//
//  unifiGoogleResource.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 11/28/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import "unifiGoogleResource.h"

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
        NSLog(@"%@",responseJSON);
        NSLog(@"%@",refreshToken);
        unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"https://www.googleapis.com/oauth2/v1/userinfo?access_token=%@",[responseJSON valueForKey:@"access_token"]] withCompleteCallback:completeCallback withErrorCallback:errorCallback];
        [object loadGetData];
    };
    [ self getAccessToken:getAccessToken withHandleError:errorCallback fromRefreshToken:refreshToken];

}
@end
