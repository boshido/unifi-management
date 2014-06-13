//
//  unifiApiConnector.h
//  UnifiManagement
//
//  Created by Boshido on 11/20/56 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^ApiCompleteCallback)(NSJSONSerialization *responseJSON,NSString *responseNSString);
typedef void(^ApiErrorCallback)(NSError *error);

static NSString *ApiServerAddress = @"127.0.0.1";

@interface unifiApiConnector : NSObject
@property(nonatomic, retain) NSURLConnection *theConnection;
@property(nonatomic, retain,getter = getUrl,setter = setUrl:) NSString * url;
@property(nonatomic, retain) NSString * parameter;
@property(nonatomic, strong) NSMutableData *receivedData;
@property(nonatomic, copy) ApiCompleteCallback onComplete;
@property(nonatomic, copy) ApiErrorCallback onError;

-(id)initWithUrl:(NSString *)initUrl withCompleteCallback:(ApiCompleteCallback)completeCallback withErrorCallback:(ApiErrorCallback)errorCallback andData:(NSString *)initParameter;
-(id)initWithUrl:(NSString *)initUrl withCompleteCallback:(ApiCompleteCallback)completeCallback withErrorCallback:(ApiErrorCallback)errorCallback;
- (void)loadGetData ;
- (void)loadPostData;
- (void)cancel;
@end
