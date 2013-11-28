//
//  unifiAppDelegate.h
//  UnifiManagement
//
//  Created by Boshido on 11/20/56 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "unifiGlobalVariable.h"
#import "unifiSplashViewController.h"
@interface unifiAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) unifiSplashViewController *splashView;
@end
