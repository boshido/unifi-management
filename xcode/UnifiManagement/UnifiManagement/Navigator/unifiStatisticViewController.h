//
//  unifiStatisticViewController.h
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 12/2/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface unifiStatisticViewController : UIViewController<UIWebViewDelegate,UIGestureRecognizerDelegate>{
    bool isWebloaded;
    BOOL isTraffic;
    NSString *timeType;
    NSInteger contentSize;
}

@property(retain,nonatomic) IBOutlet UIWebView *chart;
@property(retain,nonatomic) IBOutlet UIView *statusView,*coverView;
@property(retain,nonatomic) IBOutlet UIScrollView *scrollView;
@property(retain,nonatomic) IBOutlet UIButton *hourlyButton,*dateButton,*chartType;
@property(retain,nonatomic) IBOutlet UILabel *average,*date;
@property(retain,nonatomic) NSJSONSerialization *statistic;
@property double time;

-(IBAction)backToParent:(id)sender;
-(IBAction)backToHome:(id)sender;
-(IBAction)toggleTimeType:(id)sender;
-(IBAction)toggleChartType:(id)sender;
@end
