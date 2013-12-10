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
    spinner = [[TJSpinner alloc] initWithSpinnerType:kTJSpinnerTypeActivityIndicator];
    [spinner setColor:[UIColor colorWithRed:17/255.00 green:181/255.00 blue:255.00/255.00 alpha:1.0]];
    [spinner setStrokeWidth:20];
    [spinner setInnerRadius:6];
    [spinner setOuterRadius:15];
    [spinner setNumberOfStrokes:8];
    spinner.hidesWhenStopped = YES;
    [spinner setPatternStyle:TJActivityIndicatorPatternStylePetal];
    spinner.center = CGPointMake(160, 285);
    [spinner startAnimating];
    [self.view addSubview:spinner];
    
    // Read the XML file.
    
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"refresh_token.plist"];
   
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *value = [plistDict objectForKey:@"refresh_token"];
    if (![value isEqualToString:@""] && value != NULL) {
       [unifiGlobalVariable sharedGlobalData].refreshToken = value;
    }
    
    
    //[UIColor colorWithRed:0.106 green:0.718 blue:0.651 alpha:1.0]
    //[UIColor colorWithRed:0.173 green:0.745 blue:0.914 alpha:1.0]
}

-(void)viewDidAppear:(BOOL)animated{
    
    
    if([[unifiGlobalVariable sharedGlobalData].refreshToken isEqualToString:@""]){
        unifiGoogleNavigationController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"unifiGoogleNavigationController"];
        [spinner stopAnimating];
        
        [self presentViewController:loginView animated:NO completion:nil];
        
    }
    else{
        
        [unifiGoogleResource
            getUserData:^(NSJSONSerialization *response) {
                NSLog(@"%@",response);
                [unifiGlobalVariable sharedGlobalData].name = [response valueForKey:@"given_name"];
                [unifiGlobalVariable sharedGlobalData].surname = [response valueForKey:@"family_name"];
                [unifiGlobalVariable sharedGlobalData].email = [response valueForKey:@"email"];
                [unifiGlobalVariable sharedGlobalData].profilePicture = [response valueForKey:@"picture"];
                [self dismissViewControllerAnimated:NO completion:nil];
                [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"unifiTabViewController"] animated:NO completion:nil];
            }
            withRefreshToken:[unifiGlobalVariable sharedGlobalData].refreshToken
        ];
        
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
