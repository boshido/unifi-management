//
//  unifiSplashControllerViewController.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 11/25/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import "unifiSplashViewController.h"
#import "DejalActivityView.h"
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
//    NSString *error = [NSString stringWithFormat:@"Can not save refresh token to plist."];
//    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"refresh_token.plist"];
//    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:tokenData
//                                                                   format:NSPropertyListXMLFormat_v1_0
//                                                         errorDescription:&error];
//    if(plistData) {
//        [plistData writeToFile:plistPath atomically:YES];
//    }
//    else {
//        NSLog(@"Error : %@",error);
//    }

}

-(void)viewDidAppear:(BOOL)animated{
    
//    if(![[unifiGlobalVariable sharedGlobalData].refreshToken isEqualToString:@""]){
//        
//        
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)signIn:(id)sender{
    unifiGoogleNavigationController *google = [self.storyboard instantiateViewControllerWithIdentifier:@"unifiGoogleNavigationController"];
    google.tokenDelegate=self;
    [self presentViewController: google animated:YES completion:nil];
}

- (void)unifiGoogleNavigation:(unifiGoogleNavigationController *)viewController
 finishWithRefreshToken:(NSString*)refreshToken{
    [DejalBezelActivityView currentActivityView].showNetworkActivityIndicator = YES;
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Authenticating"];
    NSLog(@"%@",refreshToken );
    [unifiGoogleResource
     getUserData:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
         [unifiGlobalVariable sharedGlobalData].name = [responseJSON valueForKey:@"given_name"];
         [unifiGlobalVariable sharedGlobalData].surname = [responseJSON valueForKey:@"family_name"];
         [unifiGlobalVariable sharedGlobalData].email = [responseJSON valueForKey:@"email"];
         [unifiGlobalVariable sharedGlobalData].profilePicture = [responseJSON valueForKey:@"picture"];
         
         [unifiGoogleResource
          getPermission:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
              [DejalBezelActivityView removeViewAnimated:YES];
              if([[responseJSON valueForKey:@"code"] intValue]==200){
                  [unifiGlobalVariable sharedGlobalData].refreshToken = refreshToken;
                  [unifiGlobalVariable sharedGlobalData].permissionNumber = [[[responseJSON valueForKey:@"data"] valueForKey:@"gaccess"] intValue];
                  [unifiGlobalVariable sharedGlobalData].permissionName = [[responseJSON valueForKey:@"data"] valueForKey:@"gname"];
                  
                  NSLog(@"%@",@{
                                @"refreshToken":[unifiGlobalVariable sharedGlobalData].refreshToken,
                                @"permissonNumber":[NSNumber numberWithInt:[unifiGlobalVariable sharedGlobalData].permissionNumber],
                                @"permissionName":[unifiGlobalVariable sharedGlobalData].permissionName
                                });
                  
                  
                  NSString *error = [NSString stringWithFormat:@"Can not save refresh token to plist."];
                  NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                  NSString *plistPath = [rootPath stringByAppendingPathComponent:@"refresh_token.plist"];
                  NSData *plistData = [NSPropertyListSerialization
                                       dataFromPropertyList:@{
                                                              @"refreshToken":[unifiGlobalVariable sharedGlobalData].refreshToken,
                                                              @"permissonNumber":[NSNumber numberWithInt:[unifiGlobalVariable sharedGlobalData].permissionNumber],
                                                              @"permissionName":[unifiGlobalVariable sharedGlobalData].permissionName
                                                              }
                                       format:NSPropertyListXMLFormat_v1_0
                                       errorDescription:&error
                                       ];
                  if(plistData) {
                      [plistData writeToFile:plistPath atomically:YES];
                  }
                  else {
                      NSLog(@"Error : %@",error);
                  }
                  [self dismissViewControllerAnimated:YES completion:nil];
              }
              else{
                  
                  UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Permission Denied"
                                                                 message: @"You don't have permission for using this Application."
                                                                delegate: self
                                                       cancelButtonTitle:@"Ok"
                                                       otherButtonTitles:nil,nil
                                        ];
                  [alert show];
              }
          }
          withHandleError:^(NSError *error) {
              [DejalBezelActivityView removeViewAnimated:YES];
              UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Conection Failure"
                                                             message: @""
                                                            delegate: self
                                                   cancelButtonTitle:@"Ok"
                                                   otherButtonTitles:nil,nil];
              [alert show];

          }
          fromEmail:[responseJSON valueForKey:@"email"]
          ];
     }
     withHandleError:^(NSError *error) {
         UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Token Invalid"
                                                        message: @"Can not get data from google"
                                                       delegate: self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil,nil
                               ];
         [alert show];
     }
     fromRefreshToken:refreshToken
     ];
    
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleBlackTranslucent;
}
@end
