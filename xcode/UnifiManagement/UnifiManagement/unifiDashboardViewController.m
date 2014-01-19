//
//  unifiDashboard2ViewController.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 1/5/2557 BE.
//  Copyright (c) 2557 KMUTNB. All rights reserved.
//

#import "unifiDashboardViewController.h"
#import "unifiApResource.h"
#import "unifiDeviceResource.h"
#import "DejalActivityView.h"
#import "unifiFailureViewController.h"

@interface unifiDashboardViewController ()

@end

@implementation unifiDashboardViewController
@synthesize dashboardChart,apMapChart,apLabel,deviceLabel;
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
    webFlag = FALSE;
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"dashboardchart" ofType:@"html"]]];
    dashboardChart.delegate = self;
    dashboardChart.scrollView.scrollEnabled = NO;
    dashboardChart.scrollView.bounces = NO;
    [dashboardChart loadRequest:urlRequest];
    urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"apmapchart" ofType:@"html"]]];
    apMapChart.delegate = self;
    apMapChart.scrollView.scrollEnabled = NO;
    apMapChart.scrollView.bounces = NO;
    [apMapChart loadRequest:urlRequest];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self loadDashBoardInfo];
     autoLoad = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(loadDashBoardInfo) userInfo:nil repeats:YES];
}
-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"View Dissapear");
    [autoLoad invalidate];
    autoLoad = Nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// ----------------------------------   API         ------------------------------------

-(void)loadDashBoardInfo{
    NSLog(@"Still Here");
    __block bool flag1 = NO,flag2 = NO,flag3 = NO;
    
    __block float devicePercentage,apPercentage,connected,disconnected,authorized,non_authorized;
    __block NSString *apMaplist;
    
    void(^completeAll)(void) = ^void(){
        [ dashboardChart stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setValue([%f,%f])",devicePercentage, apPercentage]];
        [ apMapChart stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"showChart(%@)",apMaplist]];
        dashboardChart.alpha =1;
        apMapChart.alpha=1;
        apLabel.text = [NSString stringWithFormat:@"%.f / %.f",connected,connected+disconnected];
        deviceLabel.text = [NSString stringWithFormat:@"%.f / %.f",authorized,authorized+non_authorized];
        
        [DejalBezelActivityView removeViewAnimated:YES];
    };
    
    ApiCompleteCallback apCallback = ^(NSJSONSerialization *responseJSON,NSString * responseNSString){
        connected =[[[responseJSON valueForKey:@"data"] valueForKey:@"connected"] floatValue];
        disconnected =[[[responseJSON valueForKey:@"data"] valueForKey:@"disconnected"] floatValue];
        apPercentage = (connected/(connected+disconnected))*100;
        flag1 = YES;
        if(flag1 && flag2 && flag3){
            completeAll();
        }
        
    };
    
    ApiCompleteCallback deviceCallback = ^(NSJSONSerialization *responseJSON,NSString * responseNSString){
        authorized =[[[responseJSON valueForKey:@"data"] valueForKey:@"authorized"] floatValue];
        non_authorized =[[[responseJSON valueForKey:@"data"] valueForKey:@"non_authorized"] floatValue];
        if(authorized==0 && non_authorized==0)devicePercentage=0;
        else devicePercentage = (authorized/(authorized+non_authorized))*100;
        flag2 = YES;
        if(flag1 && flag2 && flag3){
            completeAll();
        }
    };
    
    ApiCompleteCallback apMapCallback = ^(NSJSONSerialization *responseJSON,NSString * responseNSString){
        apMaplist=responseNSString;
        flag3 = YES;
        if(flag1 && flag2 && flag3){
            completeAll();
        }
    };
    
    ApiErrorCallback errorHandle = ^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:YES];
        unifiFailureViewController *failureController = [[self storyboard] instantiateViewControllerWithIdentifier:@"unifiFailureViewController"];
        [[self navigationController] presentViewController:failureController animated:YES completion:nil];
    };
    [unifiApResource getApCount:apCallback withHandleError:errorHandle];
    [unifiDeviceResource getDeviceCount:deviceCallback withHandleError:errorHandle];
    [unifiApResource getApMapCount:apMapCallback withHandleError:errorHandle];
}


// ----------------------------------   Delegate    ------------------------------------



- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if(webFlag==TRUE){
        [DejalBezelActivityView currentActivityView].showNetworkActivityIndicator = YES;
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading."];
        [self loadDashBoardInfo];
    };
    webFlag=TRUE;
}

// ----------------------------------   Other       ------------------------------------

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleBlackTranslucent;
}
@end
