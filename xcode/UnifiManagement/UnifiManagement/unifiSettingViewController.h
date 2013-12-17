//
//  unifiSettingViewController.h
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 12/2/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJSpinner.h"

@protocol unifiSettingViewControllerDelegate;

@interface unifiSettingViewController : UIViewController{
    IBOutlet UILabel *name;
    IBOutlet UILabel *surname;
    IBOutlet UILabel *email;
    NSString *url;
    TJSpinner *spinner;
    IBOutlet UIImageView *profilePicture;
    __weak id<unifiSettingViewControllerDelegate> delegate;

}
@property(weak,nonatomic) id<unifiSettingViewControllerDelegate> delegate;

-(IBAction)signOut:(id)sender;
@end

@protocol unifiSettingViewControllerDelegate<NSObject>
- (void)settingView:(unifiSettingViewController *)viewController
             didSignoutSign:(BOOL)sign;
@end
