//
//  unifiSettingViewController.h
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 12/2/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJSpinner.h"

@interface unifiSettingViewController : UIViewController{
    IBOutlet UILabel *name;
    IBOutlet UILabel *surname;
    IBOutlet UILabel *email;
    NSString *url;
    TJSpinner *spinner;
    IBOutlet UIImageView *profilePicture;

}

-(IBAction)signOut:(id)sender;
@end