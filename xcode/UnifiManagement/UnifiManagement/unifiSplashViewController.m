//
//  unifiSplashControllerViewController.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 11/25/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import "unifiSplashViewController.h"

@interface unifiSplashViewController ()

@end

@implementation unifiSplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    TJSpinner *spinner = [[TJSpinner alloc] initWithSpinnerType:kTJSpinnerTypeActivityIndicator];
    [spinner setColor:[UIColor colorWithRed:17/255.00 green:181/255.00 blue:255.00/255.00 alpha:1.0]];
    [spinner setStrokeWidth:20];
    [spinner setInnerRadius:6];
    [spinner setOuterRadius:15];
    [spinner setNumberOfStrokes:8];
    spinner.hidesWhenStopped = NO;
    [spinner setPatternStyle:TJActivityIndicatorPatternStylePetal];
    spinner.center = CGPointMake(160, 285);
    [spinner startAnimating];
    [self.view addSubview:spinner];
    
        //[UIColor colorWithRed:0.106 green:0.718 blue:0.651 alpha:1.0]
    //[UIColor colorWithRed:0.173 green:0.745 blue:0.914 alpha:1.0]
}
-(void)viewDidAppear:(BOOL)animated{
    
    if([[unifiGlobalVariable sharedGlobalData].refreshToken isEqualToString:@""]){
        unifiGoogleNavigationController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"unifiGoogleNavigationController"];
        
        [self presentViewController:loginView animated:NO completion:nil];
        
    }
    else{
        
        [unifiGoogleResource
         getUserData:^(NSJSONSerialization *response) {
             NSLog(@"%@",response);
         }
         withRefreshToken:[unifiGlobalVariable sharedGlobalData].refreshToken
         ];
        
        [self dismissViewControllerAnimated:NO completion:nil];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
