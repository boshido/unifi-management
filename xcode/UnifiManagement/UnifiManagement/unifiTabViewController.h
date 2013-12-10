//
//  unifiTabViewController.h
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 11/29/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "unifiSettingViewController.h"

@interface unifiTabViewController : UITabBarController<UITabBarControllerDelegate,UIGestureRecognizerDelegate>
@property NSInteger controllerIndex;
@end
