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
    
    ApiCallbackComplete callback = ^(NSJSONSerialization *response){
        NSLog(@"%@",response);
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"line" ofType:@"html"]]];
        [chart loadRequest:urlRequest];
        chart.scrollView.scrollEnabled = NO;
        chart.scrollView.bounces = NO;

    };
    
    [unifiSystemResource getTrafficReport:callback withType:@"hourly"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)backToMain:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
