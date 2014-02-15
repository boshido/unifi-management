//
//  unifiSettingViewController.h
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 12/2/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJSpinner.h"

@interface unifiSettingViewController : UIViewController<UIAlertViewDelegate>{
    IBOutlet UILabel *permission;
    IBOutlet UILabel *name;
    IBOutlet UILabel *email;
    IBOutlet UIScrollView *scrollView;
    NSString *url;
    TJSpinner *spinner;
    IBOutlet UIImageView *profilePicture;
    NSJSONSerialization *settingsData;
}

-(IBAction)signOut:(id)sender;
@end