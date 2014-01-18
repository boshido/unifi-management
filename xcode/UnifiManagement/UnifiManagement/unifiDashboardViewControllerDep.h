//
//  unifiDashboardViewController.h
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 11/26/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJSpinner.h"

@interface unifiDashboardViewControllerDep : UIViewController<UITabBarControllerDelegate,UITabBarDelegate>
{
    IBOutlet UILabel *userCount,*apCount,*loading;
    IBOutlet UIView *infoView,*loadingView;
    IBOutlet UIButton *signIn;
    TJSpinner *spinner;
    NSTimer *autoLoad;
}
@property (retain,nonatomic) IBOutletCollection(UIButton) NSArray* buttons;
@property (retain,nonatomic) NSString *ap;
@property (retain,nonatomic) NSString *user;

-(IBAction)toSignIn:(id)sender;
@end
