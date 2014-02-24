//
//  unifiDashboard2ViewController.h
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 1/5/2557 BE.
//  Copyright (c) 2557 KMUTNB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface unifiDashboardViewController : UIViewController<UIWebViewDelegate>{
    bool webFlag;
    NSTimer *autoLoad;
}

@property(retain,nonatomic) IBOutlet UIWebView *dashboardChart;
@property(retain,nonatomic) IBOutlet UILabel *deviceLabel,*apLabel;
@property(retain,nonatomic) IBOutlet UIScrollView *topScrollView;
@end


/*
 //
 //  unifiDashboard2ViewController.h
 //  UnifiManagement
 //
 //  Created by Watchrapong Agsonchu on 1/5/2557 BE.
 //  Copyright (c) 2557 KMUTNB. All rights reserved.
 //
 
 #import <UIKit/UIKit.h>
 
 @interface unifiDashboardViewController : UIViewController<UIWebViewDelegate>{
 bool webFlag;
 NSTimer *autoLoad;
 }
 
 @property(retain,nonatomic) IBOutlet UIWebView *dashboardChart,*apMapChart;
 @property(retain,nonatomic) IBOutlet UILabel *deviceLabel,*apLabel;
 @end

 
 */