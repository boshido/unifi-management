//
//  unifiStatisticViewController.h
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 12/2/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface unifiStatisticViewController : UIViewController<UIWebViewDelegate,UIGestureRecognizerDelegate>{
    IBOutlet UIWebView *chart;
    IBOutlet UIView *statusView,*coverView;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIButton *hourlyButton,*dateButton;
    IBOutlet UILabel *average;
    NSString *timeType;
    double time;
    
    NSJSONSerialization *statistic;
    NSInteger contentSize;
    
}

-(IBAction)backToParent:(id)sender;
-(IBAction)backToHome:(id)sender;
-(IBAction)toggleChart:(id)sender;
@end
