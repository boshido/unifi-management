//
//  unifiSplashControllerViewController.h
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 11/25/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJSpinner.h"
#import "unifiGlobalVariable.h"
#import "unifiGoogleResource.h"
#import "unifiGoogleNavigationController.h"

@interface unifiSplashViewController : UIViewController<unifiGoogleNavigationControllerDelegate>
-(IBAction)signIn:(id)sender;
@end
