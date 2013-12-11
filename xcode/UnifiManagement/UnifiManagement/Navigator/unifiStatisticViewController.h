//
//  unifiStatisticViewController.h
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 12/2/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "unifiSystemResource.h"
#import "unifiUserResource.h"

@interface unifiStatisticViewController : UIViewController<UIWebViewDelegate>{
    IBOutlet UIWebView *chart;
    IBOutlet UIView *statusView,*summaryView;
    IBOutlet UIScrollView *scrollView;
    NSJSONSerialization *statistic;
    NSInteger contentSize;
}

-(IBAction)backToParent:(id)sender;
-(IBAction)backToHome:(id)sender;

@end
