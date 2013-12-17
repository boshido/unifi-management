//
//  unifiStatisticViewController.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 12/2/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import "unifiStatisticViewController.h"
#import "unifiSystemResource.h"
#import "unifiUserResource.h"
#import "DejalActivityView.h"
#import "unifiUITapGestureRecognizer.h"
@interface unifiStatisticViewController ()

@end

@implementation unifiStatisticViewController

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
    
    
    
    CALayer *bottomBorder = [CALayer layer];
//    CALayer *topBorder = [CALayer layer];
//    topBorder.frame = CGRectMake(0.0f, 0.0f, summaryView.frame.size.width, 1.0f);
//    topBorder.backgroundColor = [UIColor colorWithRed:0.867 green:0.867 blue:0.867 alpha:1.0].CGColor;
//    [summaryView.layer addSublayer:topBorder];
    
    bottomBorder.frame = CGRectMake(0.0f, 35, statusView.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:0.867 green:0.867 blue:0.867 alpha:1.0].CGColor;
    [statusView.layer addSublayer:bottomBorder ];
    
    [hourlyButton setSelected:YES];
    [dateButton setSelected:NO];
    timeType = @"hourly";
    time = 0.0f;
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"line" ofType:@"html"]]];
    chart.delegate = self;
    chart.scrollView.scrollEnabled = NO;
    chart.scrollView.bounces = NO;
    [chart loadRequest:urlRequest];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [chart addGestureRecognizer:swipeLeft];
    swipeLeft.delegate = self;
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [chart addGestureRecognizer:swipeRight];
    swipeRight.delegate = self;

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self showGraph];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // Intercept custom location change, URL begins with "js-call:"
    if ([[[request URL] absoluteString] hasPrefix:@"js-call:"]) {
        // Call the given selector
        
        [self performSelector:@selector(showUser:) withObject:[[[request URL] absoluteString]substringFromIndex:17 ]];
        
        // Cancel the location change
        return NO;
    }
    
    // Accept this location change
    return YES;
    
}

-(void)showGraph{
    
    [DejalBezelActivityView currentActivityView].showNetworkActivityIndicator = YES;
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading."];
    ApiCallbackComplete callback = ^(NSJSONSerialization *responseJSON,NSString *responseNSString){
        NSLog(@"%@",responseNSString);
        statistic = responseJSON;
        [ chart stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"showLineChart(%@,\"%@\")", responseNSString,timeType]];
        [DejalBezelActivityView removeViewAnimated:YES];
        NSInteger plotCount=0;
        float averageTraffic=0.0f;
        for(NSJSONSerialization *json in [statistic valueForKey:@"data"]){
            averageTraffic += [[json valueForKey:@"bytes"] floatValue];
            plotCount++;
        }
        averageTraffic /= plotCount;
        if((NSInteger)(averageTraffic/1073741824) != 0){
            average.text = [NSString stringWithFormat:@"%1.2f %@",averageTraffic/1073741824,@"GigaBytes"];
        }
        else if((NSInteger)(averageTraffic / 1048576) != 0){
            average.text = [NSString stringWithFormat:@"%1.2f %@",averageTraffic/1048576,@"MegaBytes"];
        }
        else if((NSInteger)(averageTraffic / 1024) != 0){
            average.text = [NSString stringWithFormat:@"%1.2f %@",averageTraffic/1024,@"KiloBytes"];
        }
        else{
            average.text = [NSString stringWithFormat:@"%1.2f %@",averageTraffic,@"Bytes"];
        }
       
    };
    
    [unifiSystemResource getTrafficReport:callback withStartTime:[[NSDate date] timeIntervalSince1970]+time andType:timeType];
}

-(void)showUser:(NSString *)id{
    
    contentSize = 5;
    [scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for(NSJSONSerialization *json in [statistic valueForKey:@"data"]){
        if([[json valueForKey:@"_id"] isEqualToString:id]){
            [DejalBezelActivityView currentActivityView].showNetworkActivityIndicator = YES;
            [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading."];
            [unifiUserResource
                getUser:^(NSJSONSerialization *responseJSON,NSString *responseString){
                    if(coverView.alpha==1)coverView.alpha=0;
                    if(responseJSON != nil){
                        if([[responseJSON valueForKey:@"code"] intValue] == 200){
                            NSInteger index=0;
                            for(NSJSONSerialization *json in [responseJSON valueForKey:@"data"]){
                                if([ json valueForKey:@"google_id"] == nil)continue;
                                
                                UILabel *describe,*hostname;
                                describe = [[UILabel alloc] initWithFrame:CGRectMake(11, contentSize, 185, 21)];
                                hostname = [[UILabel alloc] initWithFrame:CGRectMake(204, contentSize, 103, 21)];
                    
                                [describe setTextColor:[UIColor colorWithRed:0.663 green:0.639 blue:0.671 alpha:1.0]];
                                [describe setTextAlignment:NSTextAlignmentLeft];
                                [describe setFont:[UIFont systemFontOfSize:11]];
                                
                                NSString *describeStr = [NSString stringWithFormat:@"%@ %@",[json valueForKey:@"fname"],[json valueForKey:@"lname"]];
                                if([describeStr isEqualToString:@"- -"]){
                                   
                                    [describe setText:[json valueForKey:@"email"]];
                                }
                                else{
                                     [describe setText:describeStr];
                                }
                                
                                
                                [hostname setTextColor:[UIColor colorWithRed:0.663 green:0.639 blue:0.671 alpha:1.0]];
                                [hostname setTextAlignment:NSTextAlignmentLeft];
                                [hostname setFont:[UIFont systemFontOfSize:11]];
                                if([json valueForKey:@"hostname"] != NULL) [hostname setText:[json valueForKey:@"hostname"]];
                                else [hostname setText:[json valueForKey:@"mac"]];
                                
                                [scrollView addSubview:describe];
                                [scrollView addSubview:hostname];
                                
                                unifiUITapGestureRecognizer* describeGesture = [[unifiUITapGestureRecognizer alloc] initWithTarget:self action:@selector(describeTapped:)];
                                // if labelView is not set userInteractionEnabled, you must do so
                                [describeGesture initParameter];
                                [describeGesture setParameter:[json valueForKey:@"google_id"] withKey:@"google_id"];
                                [describe setUserInteractionEnabled:YES];
                                [describe addGestureRecognizer:describeGesture];
                                
                                unifiUITapGestureRecognizer* hostnameGesture = [[unifiUITapGestureRecognizer alloc] initWithTarget:self action:@selector(hostnameTapped:)];
                                // if labelView is not set userInteractionEnabled, you must do so
                                [hostnameGesture initParameter];
                                [hostnameGesture setParameter:[json valueForKey:@"mac"] withKey:@"mac"];
                                [hostname setUserInteractionEnabled:YES];
                                [hostname addGestureRecognizer:hostnameGesture];
                                
                                contentSize+=20;
                                [scrollView setContentSize:CGSizeMake(68, contentSize)];
                                
                            }
                            index++;
                        }
                    }
                    [DejalBezelActivityView removeViewAnimated:YES];
                }
                FromMac:[json valueForKey:@"guest_macs"]
            ];
        }
    }
}

-(void) swipeRight:(UISwipeGestureRecognizer *) recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        if([timeType isEqualToString:@"hourly"]){
            time -= 60*60*7;
        }
        else{
            time -= 60*60*24*7;
            //NSLog(@"%f",[[NSDate date] timeIntervalSince1970]+time);
        }
        [self showGraph];
        NSLog(@"Swipe Right");
    }
}

-(void) swipeLeft:(UISwipeGestureRecognizer *) recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        if([timeType isEqualToString:@"hourly"]){
            time += 60*60*7;
        }
        else{
             time += 60*60*24*7;
            
          // NSLog(@"%f",[[NSDate date] timeIntervalSince1970]+time);
        }
        [self showGraph];
        NSLog(@"Swipe Left");
    }

}
-(void)describeTapped:(unifiUITapGestureRecognizer*)gestureRecognizer{
    NSLog(@"%@",[gestureRecognizer getParameterByKey:@"google_id"]);
}

-(void)hostnameTapped:(unifiUITapGestureRecognizer*)gestureRecognizer{
    NSLog(@"%@",[gestureRecognizer getParameterByKey:@"mac"]);
}


-(IBAction)backToParent:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)backToHome:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(IBAction)toggleChart:(id)sender{
    UIButton *button = (UIButton *)sender;
    if(!button.selected){
        if([button tag] == 1) { // Hours Pressed
            [dateButton setSelected:NO];
            timeType = @"hourly";
            time = 0.0f;
            [self showGraph];
        }
        else {  // Date Pressed
            [hourlyButton setSelected:NO];
            timeType = @"daily";
            time = 0.0f;
            [self showGraph];
        }
        
        [button setSelected:YES];
    }
}

@end
