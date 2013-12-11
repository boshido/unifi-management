//
//  unifiGoogleResource.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 11/28/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import "unifiGoogleResource.h"

@implementation unifiGoogleResource
+(void)getAccessToken:(ApiCallbackComplete)callback withRefreshToken:(NSString *)refreshToken{
    
    NSString *clientId = @"422391959017-g7pjv4dcgfqrahuad57nftm3s7jkct40.apps.googleusercontent.com";
    NSString *clientSecret = @"NfkcgQKYWoczllzdZXr7VSSj";
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:@"https://accounts.google.com/o/oauth2/token"
    andData:[NSString stringWithFormat:@"client_id=%@&client_secret=%@&refresh_token=%@&grant_type=refresh_token",
             clientId,clientSecret,refreshToken]
    andCallback:callback];
    
    [object loadPostData];
    //http://202.44.47.47/fitmmon/v3/webui/apiv2/loginAPI.php?email=
    //{code: data:{gname:}}
}

+(void)getUserData:(ApiCallbackComplete)callback withRefreshToken:(NSString *)refreshToken{
    
    ApiCallbackComplete getAccessToken = ^(NSJSONSerialization *responseJSON,NSString *responseNSString){
        NSLog(@"%@",responseJSON);
         NSLog(@"%@",refreshToken);
        unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:[NSString stringWithFormat:@"https://www.googleapis.com/oauth2/v1/userinfo?access_token=%@",[responseJSON valueForKey:@"access_token"]]  andCallback:callback];
        [object loadGetData];
    };
    [ self getAccessToken:getAccessToken withRefreshToken:refreshToken];

}
@end
