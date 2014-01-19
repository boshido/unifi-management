//
//  unifiFailureViewController.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 1/18/2557 BE.
//  Copyright (c) 2557 KMUTNB. All rights reserved.
//

#import "unifiFailureViewController.h"
#import "unifiSystemResource.h"
#import "DejalActivityView.h"
@interface unifiFailureViewController ()

@end

@implementation unifiFailureViewController
@synthesize  delegate,selector;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)retry:(id)sender{
    [DejalBezelActivityView currentActivityView].showNetworkActivityIndicator = YES;
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading."];
    [unifiSystemResource testConection:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
        [DejalBezelActivityView removeViewAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:^{
            if([self.delegate respondsToSelector:@selector(failureView:retryWithSel:) ]){
                if(selector != nil){
                    IMP imp = [self methodForSelector:selector];
                    void (*func)(id, SEL) = (void *)imp;
                    func(self, selector);
                }
                [self.delegate failureView:self retryWithSel:selector];
            }
        }];
    } withHandleError:^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:YES];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Conection Failure"
                                                       message: @""
                                                      delegate: self
                                             cancelButtonTitle:@"Ok"
                                             otherButtonTitles:nil,nil];
        [alert show];
    }];
     
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleBlackTranslucent;
}
@end
