//
//  unifiApiConnector.m
//  UnifiManagement
//
//  Created by Boshido on 11/20/56 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import "unifiApiConnector.h"

@implementation unifiApiConnector
@synthesize url,parameter,receivedData,onComplete;

-(id)initWithUrl:(NSString *)initUrl withCompleteCallback:(ApiCompleteCallback)completeCallback withErrorCallback:(ApiErrorCallback)errorCallback andData:(NSString *)initParameter {
    
    self.onComplete = completeCallback;
    self.onError = errorCallback;
    self.url = initUrl;
    self.parameter = initParameter;
    return self;
}

-(id)initWithUrl:(NSString *)initurl withCompleteCallback:(ApiCompleteCallback)completeCallback withErrorCallback:(ApiErrorCallback)errorCallback{

    self.onComplete = completeCallback;
    self.onError = errorCallback;
    self.url = initurl;
    self.parameter = @"";
    return self;
}

-(void)loadGetData {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                    cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                timeoutInterval:60.0];

    theConnection=[[NSURLConnection alloc] initWithRequest:request  delegate:self startImmediately:YES];
    if (!theConnection) {
        // Release the receivedData object.
        receivedData = nil;
        // Inform the user that the connection failed.
    }
}

-(void)loadPostData {
    
     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                       timeoutInterval:60.0];
    // Create the request.
    // Specify that it will be a POST request
    request.HTTPMethod = @"POST";
    
    // This is how we set header fields
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    // Convert your data and set your request's HTTPBody property
    NSData *requestBodyData = [parameter dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBodyData;
    
    theConnection=[[NSURLConnection alloc] initWithRequest:request  delegate:self startImmediately:YES];
    if (!theConnection) {
        // Release the receivedData object.
        receivedData = nil;
        // Inform the user that the connection failed.
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
   
    receivedData = [[NSMutableData alloc] initWithLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //NSLog(@"Collect");
    [ receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    receivedData = nil;
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    if(self.onError != nil)self.onError(error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.onComplete([NSJSONSerialization JSONObjectWithData:receivedData options:kNilOptions error:nil],[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding]);
    
    theConnection = nil;
    receivedData = nil;
}
@end
