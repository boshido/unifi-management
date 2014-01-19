//
//  unifiSettingViewController.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 12/2/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import "unifiSettingViewController.h"
#import "unifiGlobalVariable.h"
#import "unifiApiConnector.h"
#import "unifiGoogleResource.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "unifiTabViewController.h"

@interface unifiSettingViewController ()

@end

@implementation unifiSettingViewController
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
    spinner.center = CGPointMake(62, 85);
    [spinner startAnimating];
    [self.view addSubview:spinner];
    // border radius
    [profilePicture.layer setCornerRadius:47.5f];
    [profilePicture.layer setMasksToBounds: YES];
    // border
    [profilePicture.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [profilePicture.layer setBorderWidth:0.3f];
   
    __weak typeof(profilePicture) profilePictureWeak = profilePicture;
     __weak typeof(spinner) spinnerWeak = spinner;
    
    name.text = [unifiGlobalVariable sharedGlobalData].name;
    surname.text = [unifiGlobalVariable sharedGlobalData].surname;
    email.text  = [unifiGlobalVariable sharedGlobalData].email;
    [profilePicture setImageWithURL:[NSURL URLWithString:[ unifiGlobalVariable sharedGlobalData].profilePicture]
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                              
                              [UIView animateWithDuration:0.5
                                                    delay:0.0  /* do not add a delay because we will use performSelector. */
                                                  options:UIViewAnimationOptionCurveEaseOut
                                               animations:^ {
                                                   profilePictureWeak.alpha = 1.0;
                                               }
                                               completion:^(BOOL finished) {
                                                   // [myLabel1 removeFromSuperview];
                                               }];
                              
                              [spinnerWeak stopAnimating];
                          }
     ];


}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)signOut:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Comfirm Dialog"
                                                   message: @"Do you really want to signout"
                                                  delegate: self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"OK",nil];
    
    
    [alert show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSLog(@"user pressed Button Indexed 0");
        // Any action can be performed here
    }
    else
    {
         ApiCompleteCallback completeCallback = ^(NSJSONSerialization *responseJSON,NSString * responseNSString){
             NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
             NSString *plistPath = [rootPath stringByAppendingPathComponent:@"refresh_token.plist"];
         
             NSError *error;
             if(![[NSFileManager defaultManager] removeItemAtPath:plistPath error:&error])
             {
                 //TODO: Handle/Log error
             }
             [unifiGlobalVariable initialValue];
             [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"unifiSplashViewController"] animated:NO completion:nil];
             
//             [self.tabBarController.delegate
//              tabBarController:self.tabBarController
//              shouldSelectViewController:[self.tabBarController.viewControllers objectAtIndex:0]];  // send didSelectViewController to the tabBarController delegate
         };
         unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:@"https://accounts.google.com/Logout" withCompleteCallback:completeCallback withErrorCallback:nil];
         [object loadGetData];
    }
}
@end
