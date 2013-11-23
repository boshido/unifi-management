//
//  unifiApiConnector.h
//  UnifiManagement
//
//  Created by Boshido on 11/20/56 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface unifiApiConnector : NSURLConnection{
    NSURLConnection *theConnection;
   // SEL onComplete;
//    NSMutableData *receivedData;
//    long long contentLength;
//    NSJSONSerialization *jsonObject;
}
@property(nonatomic, strong) NSMutableData *receivedData;
@property(nonatomic, copy) void (^onComplete)(NSJSONSerialization *response);
//- (NSString *)getDataFrom:(NSString *)url;

- (void)getTest:(NSString *)url withCallback:(void (^)(NSJSONSerialization *response))callbackBlock ;
@end
