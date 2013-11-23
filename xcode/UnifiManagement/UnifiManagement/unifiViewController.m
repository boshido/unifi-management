//
//  unifiViewController.m
//  UnifiManagement
//
//  Created by Boshido on 11/20/56 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import "unifiViewController.h"

@interface unifiViewController ()

@end

@implementation unifiViewController
typedef void(^ApiCallback)(NSJSONSerialization *response);

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    ApiCallback apCallback = ^(NSJSONSerialization *response){
        NSInteger connected =[[[response valueForKey:@"data"] valueForKey:@"connected"] intValue];
        NSInteger disconnected =[[[response valueForKey:@"data"] valueForKey:@"disconnected"] intValue];
        
        
        apCount.text = [NSString stringWithFormat:@"%ld / %ld",connected,connected+disconnected];
    };
    ApiCallback userCallback = ^(NSJSONSerialization *response){
        NSInteger authorized =[[[response valueForKey:@"data"] valueForKey:@"authorized"] intValue];
        NSInteger non_authorized =[[[response valueForKey:@"data"] valueForKey:@"non_authorized"] intValue];
        
        
        userCount.text = [NSString stringWithFormat:@"%ld / %ld",authorized,authorized+non_authorized];
    };
    
    unifiApResource *apConnector = [[unifiApResource alloc] init];
    unifiUserResource *userConnector = [[unifiUserResource alloc] init];
    [apConnector getApCount:apCallback];
    [userConnector getUserCount:userCallback];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)btnPressed{
    header.text = @"HAHA";
}
@end
