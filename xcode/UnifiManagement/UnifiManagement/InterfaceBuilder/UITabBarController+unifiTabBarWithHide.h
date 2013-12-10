//
//  UITabBarController+unifiTabBarWithHide.h
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 12/9/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (unifiTabBarWithHide)

@property (nonatomic, getter=isTabBarHidden) BOOL tabBarHidden;
- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated;

@end
