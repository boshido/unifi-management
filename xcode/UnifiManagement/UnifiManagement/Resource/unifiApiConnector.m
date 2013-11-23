//
//  unifiApiConnector.m
//  UnifiManagement
//
//  Created by Boshido on 11/20/56 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import "unifiApiConnector.h"

@implementation unifiApiConnector
@synthesize receivedData;

-(void)getTest:(NSString *)url withCallback:(void (^)(NSJSONSerialization *response))callbackBlock {
    // Create the request.
    self.onComplete = callbackBlock;
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    // Create the NSMutableData to hold the received data.
    // receivedData is an instance variable declared elsewhere.
    //receivedData = [NSMutableData dataWithCapacity: 0];
    
    // create the connection with the request
    // and start loading the data
    theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (!theConnection) {
        // Release the receivedData object.
        receivedData = nil;
        // Inform the user that the connection failed.
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Response");
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
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Finish");
    self.onComplete([NSJSONSerialization JSONObjectWithData:receivedData options:kNilOptions error:nil]);
    // do something with the data
    // receivedData is declared as a property elsewhere
//    NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
//    jsonObject = [NSJSONSerialization JSONObjectWithData:receivedData options:kNilOptions error:nil];
//    NSLog(@"%@",[jsonObject valueForKey:@"data"]);
//    NSArray *arr = [jsonObject valueForKey:@"data"];
//    NSLog(@"%@",[[arr objectAtIndex:0] valueForKey:@"adopt_state"]);
//    // Release the connection and the data object
//    // by setting the properties (declared elsewhere)
//    // to nil.  Note that a real-world app usually
//    // requires the delegate to manage more than one
//    // connection at a time, so these lines would
//    // typically be replaced by code to iterate through
//    // whatever data structures you are using.
    theConnection = nil;
    receivedData = nil;
}
@end
