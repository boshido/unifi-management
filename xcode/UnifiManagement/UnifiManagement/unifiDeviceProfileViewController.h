//
//  unifiDeviceProfileViewController.h
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 1/20/2557 BE.
//  Copyright (c) 2557 KMUTNB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface unifiDeviceProfileViewController : UIViewController<UIWebViewDelegate,UIGestureRecognizerDelegate>
@property(retain,nonatomic) IBOutlet UILabel *hostname,*mac,*ip,*wlan,*group,*download,*upload,*activity,*signal;
@property(retain,nonatomic) IBOutlet UIImageView *signalImg,*deviceImg,*statusImg;
@property(retain,nonatomic) IBOutlet UIButton *blockBtn,*authorizeBtn;
@property(retain,nonatomic) IBOutlet UIWebView *statisticChart;
@property(retain,nonatomic) NSJSONSerialization *deviceData;
@property(retain,nonatomic) NSString *deviceMac;

-(IBAction)backToParent:(id)sender;
-(IBAction)blockDevice:(id)sender;
-(IBAction)authorizeDevice:(id)sender;
-(IBAction)viewHistory:(id)sender;
@end
