//
//  unifiStatisticViewController.h
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 12/2/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "unifiSystemResource.h"

@interface unifiStatisticViewController : UIViewController{
    IBOutlet UIWebView *chart;
    IBOutlet UIView *statusView,*summaryView;
}
-(IBAction)backToMain:(id)sender;
@end
