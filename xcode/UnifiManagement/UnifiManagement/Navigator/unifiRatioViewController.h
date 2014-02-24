//
//  unifiRatioViewController.h
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 2/19/2557 BE.
//  Copyright (c) 2557 KMUTNB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface unifiRatioViewController : UIViewController<UIWebViewDelegate,UIGestureRecognizerDelegate>
@property(retain,nonatomic) IBOutlet UIWebView *ratioChart;
@property(retain,nonatomic) IBOutlet UILabel *header,*alertLabel;
@property(retain,nonatomic) IBOutlet UIButton *leftButton,*rightButton;
@end
