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
#import "unifiSystemResource.h"
#import "unifiTableList.h"
#import "unifiUITapGestureRecognizer.h"
#import "unifiUserProfileViewController.h"
#import "unifiDeviceProfileViewController.h"

@interface unifiDashboardViewController ()

@end

@implementation unifiDashboardViewController{
    bool loadingFlag;
}
@synthesize topScrollView,dashboardChart,apLabel,deviceLabel;
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

-(void)viewDidAppear:(BOOL)animated{
    loadingFlag = true;
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"dashboardchart" ofType:@"html"]]];
    dashboardChart.delegate = self;
    dashboardChart.scrollView.scrollEnabled = NO;
    dashboardChart.scrollView.bounces = NO;
    [dashboardChart loadRequest:urlRequest];
    
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
    if (loadingFlag) {
        [DejalBezelActivityView currentActivityView].showNetworkActivityIndicator = YES;
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading."];
    }
    __block bool flag1 = NO,flag2 = NO,flag3 = NO;
    
    __block float devicePercentage,apPercentage,connected,disconnected,authorized,non_authorized;
    
    unifiTableList *topList = [[unifiTableList alloc] initWithFrame:CGRectMake(20, 7, 280, 0)];
    topList.header.text = @"Top Traffic Usage";
    topList.firstColumn.text = @"Hostname";
    topList.secondColumn.text= @"Usage";
    topList.subjectColumnSize = topList.subjectColumnSize-15;
    topList.secondColumnX = topList.secondColumnX-5;
    topList.firstColumnX = topList.firstColumnX-10;
    topList.firstColumnSize = topList.firstColumnSize+10;
    
    
    void(^completeAll)(void) = ^void(){
        [ dashboardChart stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setValue([%f,%f])",devicePercentage, apPercentage]];
        dashboardChart.alpha =1;
        apLabel.text = [NSString stringWithFormat:@"%.f / %.f",connected,connected+disconnected];
        deviceLabel.text = [NSString stringWithFormat:@"%.f / %.f",authorized,authorized+non_authorized];
        [topScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [topScrollView addSubview:topList];
        [topScrollView setContentSize:CGSizeMake(300, topList.contentSize + topList.frame.origin.y+10)];
        
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
    
    ApiCompleteCallback topTenCallback = ^(NSJSONSerialization *responseJSON,NSString * responseNSString){
        for(NSJSONSerialization *json in [responseJSON valueForKey:@"data"]){
            if([[json valueForKey:@"is_auth"] boolValue]){
                
                UILabel *name;
                if([json valueForKey:@"name"] != [NSNull null]) name =  [unifiTableList generateUILabelWithTitle:[json valueForKey:@"name"]];
                else name =  [unifiTableList generateUILabelWithTitle:[json valueForKey:@"email"]];
                
                UILabel *hostname;
                if([json valueForKey:@"hostname"] != [NSNull null]) hostname = [unifiTableList generateUILabelWithTitle:[json valueForKey:@"hostname"]];
                else hostname = [unifiTableList generateUILabelWithTitle:[json valueForKey:@"mac"]];
                
                hostname.textColor = [UIColor colorWithRed:0.663 green:0.639 blue:0.671 alpha:1.0];
                
                UILabel *usage = [unifiTableList generateUILabelWithTitle:[self getValueWithUnit:[[json valueForKey:@"bytes"] longLongValue] ] ];
                usage.textAlignment = NSTextAlignmentRight;
                usage.textColor = [UIColor colorWithRed:0.106 green:0.718 blue:0.651 alpha:1.0];
                
                unifiUITapGestureRecognizer* nameGesture = [[unifiUITapGestureRecognizer alloc] initWithTarget:self action:@selector(nameTapped:)];
                // if labelView is not set userInteractionEnabled, you must do so
                [nameGesture initParameter];
                [nameGesture setParameter:[json valueForKey:@"google_id"] withKey:@"google_id"];
                [name setUserInteractionEnabled:YES];
                [name addGestureRecognizer:nameGesture];
                
                unifiUITapGestureRecognizer* hostnameGesture = [[unifiUITapGestureRecognizer alloc] initWithTarget:self action:@selector(hostnameTapped:)];
                // if labelView is not set userInteractionEnabled, you must do so
                [hostnameGesture initParameter];
                [hostnameGesture setParameter:[json valueForKey:@"mac"] withKey:@"mac"];
                [hostname setUserInteractionEnabled:YES];
                [hostname addGestureRecognizer:hostnameGesture];
                
                [topList addRowWithSubjectView:name andFirstColumnView:hostname andSecondColumnView:usage];
                
            }
            else{
                
                UILabel *hostname;
                if([json valueForKey:@"hostname"] != [NSNull null]) hostname = [unifiTableList generateUILabelWithTitle:[json valueForKey:@"hostname"]];
                else hostname = [unifiTableList generateUILabelWithTitle:[json valueForKey:@"mac"]];
                
                hostname.textColor = [UIColor colorWithRed:0.663 green:0.639 blue:0.671 alpha:1.0];
                
                UILabel *usage = [unifiTableList generateUILabelWithTitle:[self getValueWithUnit:[[json valueForKey:@"bytes"] doubleValue] ] ];
                usage.textAlignment = NSTextAlignmentRight;
                usage.textColor = [UIColor colorWithRed:0.106 green:0.718 blue:0.651 alpha:1.0];
                
                
                unifiUITapGestureRecognizer* hostnameGesture = [[unifiUITapGestureRecognizer alloc] initWithTarget:self action:@selector(hostnameTapped:)];
                // if labelView is not set userInteractionEnabled, you must do so
                [hostnameGesture initParameter];
                [hostnameGesture setParameter:[json valueForKey:@"mac"] withKey:@"mac"];
                [hostname setUserInteractionEnabled:YES];
                [hostname addGestureRecognizer:hostnameGesture];
                
                [topList addRowWithSubjectString:@"Unknown" andFirstColumnView:hostname andSecondColumnView:usage];
                
            }
        }
        
        flag3 = YES;
        if(flag1 && flag2 && flag3){
            completeAll();
        }
    };
    
    ApiErrorCallback errorHandle = ^(NSError *error) {
        if (loadingFlag) {
            [DejalBezelActivityView removeViewAnimated:YES];
        }
        unifiFailureViewController *failureController = [[self storyboard] instantiateViewControllerWithIdentifier:@"unifiFailureViewController"];
        [[self navigationController] presentViewController:failureController animated:YES completion:nil];
    };
    
    [unifiApResource getApCount:apCallback withHandleError:errorHandle];
    [unifiDeviceResource getDeviceCount:deviceCallback withHandleError:errorHandle];
    [unifiSystemResource getTopTenTrafficUserReport:topTenCallback withHandleError:errorHandle fromStartTime:[[NSDate date] timeIntervalSince1970] andType:@"hourly"];
}


// ----------------------------------   Delegate    ------------------------------------

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    loadingFlag=true;
    [self loadDashBoardInfo];
    loadingFlag=false;
}

// ----------------------------------   Other       ------------------------------------
-(void)nameTapped:(unifiUITapGestureRecognizer*)gestureRecognizer{
    NSLog(@"%@",[gestureRecognizer getParameterByKey:@"google_id"]);
    unifiUserProfileViewController *userProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"unifiUserProfileViewController"];
    userProfile.googleId= [gestureRecognizer getParameterByKey:@"google_id"];
    
    [self.navigationController pushViewController:userProfile animated:YES];
    
}

-(void)hostnameTapped:(unifiUITapGestureRecognizer*)gestureRecognizer{
    NSLog(@"%@",[gestureRecognizer getParameterByKey:@"mac"]);
    unifiDeviceProfileViewController *deviceProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"unifiDeviceProfileViewController"];
    deviceProfile.deviceMac = [gestureRecognizer getParameterByKey:@"mac"];
    
    [self.navigationController pushViewController:deviceProfile animated:YES];
}

-(NSString *)getValueWithUnit:(float)value{
    if((NSInteger)(value/1073741824) != 0){
        value = value / 1073741824;
        return [NSString stringWithFormat:@"%.1f %@",value,@"GB"];
    }
    else if((NSInteger)(value / 1048576) != 0){
        value = value / 1048576;
        return [NSString stringWithFormat:@"%.1f %@",value,@"MB"];
    }
    else if((NSInteger)(value / 1024) != 0){
        value = value / 1024;
        return [NSString stringWithFormat:@"%.1f %@",value,@"KB"];
    }
    else{
        return [NSString stringWithFormat:@"%.1f %@",value,@"B"];
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleBlackTranslucent;
}
@end






/*
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
 #import "unifiSystemResource.h"
 
 @interface unifiDashboardViewController ()
 
 @end
 
 @implementation unifiDashboardViewController{
 bool loadingFlag;
 }
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
 
 }
 
 -(void)viewDidAppear:(BOOL)animated{
 webFlag = FALSE;
 loadingFlag = true;
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
 if (loadingFlag) {
 [DejalBezelActivityView currentActivityView].showNetworkActivityIndicator = YES;
 [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading."];
 }
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
 if (loadingFlag) {
 [DejalBezelActivityView removeViewAnimated:YES];
 }
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
 loadingFlag=true;
 [self loadDashBoardInfo];
 loadingFlag=false;
 };
 webFlag=TRUE;
 }
 
 // ----------------------------------   Other       ------------------------------------
 
 -(UIStatusBarStyle)preferredStatusBarStyle{
 return UIStatusBarStyleBlackTranslucent;
 }
 @end

 */
