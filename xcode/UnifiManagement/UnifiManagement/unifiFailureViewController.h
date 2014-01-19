//
//  unifiFailureViewController.h
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 1/18/2557 BE.
//  Copyright (c) 2557 KMUTNB. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol unifiFailureViewControllerDelegate;

@interface unifiFailureViewController : UIViewController
@property id<unifiFailureViewControllerDelegate>delegate;
@property SEL selector;
-(IBAction)retry:(id)sender;
@end

@protocol unifiFailureViewControllerDelegate<NSObject>
- (void)failureView:(unifiFailureViewController *)viewController
       retryWithSel:(SEL)selector;
@end


