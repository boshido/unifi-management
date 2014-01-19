//
//  unifiGoogleViewController.h
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 11/28/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "unifiGlobalVariable.h"
@interface unifiGoogleViewController : UIViewController<UIWebViewDelegate>
{
    NSURLConnection *theConnection;
    NSMutableData *receivedData;
}
@property (nonatomic, retain) IBOutlet UIWebView *webview;

-(IBAction)cancelAuthenticaiton:(id)sender;
-(IBAction)backButtonPressed:(id)sender;
@end
