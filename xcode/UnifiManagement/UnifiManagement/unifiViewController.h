//
//  unifiViewController.h
//  UnifiManagement
//
//  Created by Boshido on 11/20/56 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "unifiApResource.h"
#import "unifiUserResource.h"
#import "unifiSplashViewController.h"
#import "unifiDashboardViewController.h"
#import "MHTabBarSegue.h"
@interface unifiViewController : UIViewController{
   // IBOutlet UIviewco
}
@property(strong,nonatomic) NSString *apCount;
@property(strong,nonatomic) NSString *userCount;

@property (weak,nonatomic) UIViewController *destinationViewController;
@property (strong, nonatomic) NSString *destinationIdentifier;
@property (strong, nonatomic) UIViewController *oldViewController;


@property (weak, nonatomic) IBOutlet UIView *container;
@property (nonatomic) IBOutletCollection(UIButton) NSArray *menuBarButtons;

@end
