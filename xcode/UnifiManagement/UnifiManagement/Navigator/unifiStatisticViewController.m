//
//  unifiStatisticViewController.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 12/2/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import "unifiStatisticViewController.h"

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
    
    
    CALayer *topBorder = [CALayer layer];
    CALayer *bottomBorder = [CALayer layer];

    topBorder.frame = CGRectMake(0.0f, 0.0f, summaryView.frame.size.width, 1.0f);
    topBorder.backgroundColor = [UIColor colorWithRed:0.867 green:0.867 blue:0.867 alpha:1.0].CGColor;
    [summaryView.layer addSublayer:topBorder];
    
    bottomBorder.frame = CGRectMake(0.0f, 50.0f, statusView.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:0.867 green:0.867 blue:0.867 alpha:1.0].CGColor;
    [statusView.layer addSublayer:bottomBorder ];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"line" ofType:@"html"]]];
    chart.delegate = self;
    chart.scrollView.scrollEnabled = NO;
    chart.scrollView.bounces = NO;
    [chart loadRequest:urlRequest];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)backToParent:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)backToHome:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    ApiCallbackComplete callback = ^(NSJSONSerialization *responseJSON,NSString *responseNSString){
        statistic = responseJSON;
        [ chart stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"showLineChart(%@)", responseNSString]];
    };
    
    [unifiSystemResource getTrafficReport:callback withType:@"hourly"];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // Intercept custom location change, URL begins with "js-call:"
    if ([[[request URL] absoluteString] hasPrefix:@"js-call:"]) {
        
//        // Extract the selector name from the URL
//        NSArray *components = [requestString componentsSeparatedByString:@":"];
//        NSString *function = [components objectAtIndex:1];
//        
        // Call the given selector
        
        [self performSelector:@selector(showUser:) withObject:[[[request URL] absoluteString]substringFromIndex:17 ]];
        
        // Cancel the location change
        return NO;
    }
    
    // Accept this location change
    return YES;
    
}

-(void)showUser:(NSString *)id{
    contentSize = 30;
    [scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for(NSJSONSerialization *json in [statistic valueForKey:@"data"]){
        if([[json valueForKey:@"_id"] isEqualToString:id]){
            [unifiUserResource
                getUser:^(NSJSONSerialization *responseJSON,NSString *responseString){
                    
                    if(responseJSON != nil){
                        if([[responseJSON valueForKey:@"code"] intValue] == 200){
                            for(NSJSONSerialization *json in [responseJSON valueForKey:@"data"]){
                                if([ json valueForKey:@"google_id"] == nil)continue;
                                
                                UILabel *email,*name,*hostname;
                                email = [[UILabel alloc] initWithFrame:CGRectMake(14, contentSize, 92, 21)];
                                name = [[UILabel alloc] initWithFrame:CGRectMake(115, contentSize, 116, 21)];
                                hostname = [[UILabel alloc] initWithFrame:CGRectMake(244, contentSize, 66, 21)];
                                
                                [email setText:[json valueForKey:@"email"]];
                                [email setTextColor:[UIColor colorWithRed:0.663 green:0.639 blue:0.671 alpha:1.0]];
                                [email setTextAlignment:NSTextAlignmentLeft];
                                [email setFont:[UIFont systemFontOfSize:11]];
                                [name setText:[NSString stringWithFormat:@"%@ %@",[json valueForKey:@"fname"],[json valueForKey:@"lname"]]];
                                [name setTextColor:[UIColor colorWithRed:0.663 green:0.639 blue:0.671 alpha:1.0]];
                                [name setTextAlignment:NSTextAlignmentLeft];
                                [name setFont:[UIFont systemFontOfSize:11]];
                                [hostname setText:[json valueForKey:@"hostname"]];
                                [hostname setTextColor:[UIColor colorWithRed:0.663 green:0.639 blue:0.671 alpha:1.0]];
                                [hostname setTextAlignment:NSTextAlignmentLeft];
                                [hostname setFont:[UIFont systemFontOfSize:11]];
                                
                                [scrollView addSubview:email];
                                [scrollView addSubview:name];
                                [scrollView addSubview:hostname];
                                
                                contentSize+=20;
                                [scrollView setContentSize:CGSizeMake(68, contentSize)];
                                NSLog(@"Loop");
                            }
                        }
                    }
                }
                FromMac:[json valueForKey:@"guest_macs"]
            ];
        }
    }
}
@end
