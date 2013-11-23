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

@interface unifiViewController : UIViewController<UIAlertViewDelegate>{
    IBOutlet UILabel *header;
    IBOutlet UILabel *userCount;
    IBOutlet UILabel *apCount;
}
-(IBAction)btnPressed;
@end
