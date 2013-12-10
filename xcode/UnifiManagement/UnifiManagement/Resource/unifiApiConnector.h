//
//  unifiApiConnector.h
//  UnifiManagement
//
//  Created by Boshido on 11/20/56 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^ApiCallbackComplete)(NSJSONSerialization *response);
static NSString *ApiServerAddress = @"192.168.0.2";

@interface unifiApiConnector : NSObject{
    NSURLConnection *theConnection;
}
@property(nonatomic, retain) NSString * url;
@property(nonatomic, retain) NSString * parameter;
@property(nonatomic, strong) NSMutableData *receivedData;
@property(nonatomic, copy) ApiCallbackComplete onComplete;

- (id)initWithUrl:(NSString *)initUrl andData:(NSString *)initParameter andCallback:(ApiCallbackComplete)callbackBlock;
- (id)initWithUrl:(NSString *)url andCallback:(ApiCallbackComplete)callbackBlock;
- (void)loadGetData ;
- (void)loadPostData;
@end
