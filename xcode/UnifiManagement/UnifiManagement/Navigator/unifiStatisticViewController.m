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
#import "unifiDeviceResource.h"
#import "DejalActivityView.h"
#import "unifiUITapGestureRecognizer.h"
#import "unifiDeviceProfileViewController.h"
#import "unifiUserProfileViewController.h"
#import "unifiFailureViewController.h"
#import "unifiTableList.h"
@interface unifiStatisticViewController ()

@end

@implementation unifiStatisticViewController{
    ApiErrorCallback handleError;
}
@synthesize chart,statusView,coverView,scrollView,hourlyButton,dateButton,average,date,time,chartType;

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
    
    
    
//    CALayer *bottomBorder = [CALayer layer];
//    CALayer *topBorder = [CALayer layer];
//    topBorder.frame = CGRectMake(0.0f, 0.0f, summaryView.frame.size.width, 1.0f);
//    topBorder.backgroundColor = [UIColor colorWithRed:0.867 green:0.867 blue:0.867 alpha:1.0].CGColor;
//    [summaryView.layer addSublayer:topBorder];
    
//    bottomBorder.frame = CGRectMake(0.0f, statusView.frame.size.height, statusView.frame.size.width, 1.0f);
//    bottomBorder.backgroundColor = [UIColor colorWithRed:0.867 green:0.867 blue:0.867 alpha:1.0].CGColor;
//    [statusView.layer addSublayer:bottomBorder ];
    isTraffic = YES;
    [hourlyButton setSelected:YES];
    [dateButton setSelected:NO];
    timeType = @"hourly";
    time = 0.0f;
    isWebloaded = NO;
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [chart addGestureRecognizer:swipeLeft];
    swipeLeft.delegate = self;
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [chart addGestureRecognizer:swipeRight];
    swipeRight.delegate = self;
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"trafficchart" ofType:@"html"]]];
    chart.delegate = self;
    chart.scrollView.scrollEnabled = NO;
    chart.scrollView.bounces = NO;
    [chart loadRequest:urlRequest];
    
    __weak typeof(self) weakSelf=self;
    handleError= ^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:YES];
        unifiFailureViewController *failureController = [[weakSelf storyboard] instantiateViewControllerWithIdentifier:@"unifiFailureViewController"];
        [[weakSelf navigationController] presentViewController:failureController animated:YES completion:nil];
    };
    
}

- (void)viewDidAppear:(BOOL)animated{
//   if(isWebloaded)[self showGraph];
    
    NSLog(@"View loaded");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"Web loaded");
    chart.alpha=1;
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
    ApiCompleteCallback completeCallback = ^(NSJSONSerialization *responseJSON,NSString *responseNSString){
//        [chart performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:[NSString stringWithFormat:@"setValue(%@,\"%@\",%@)", responseNSString,timeType,isTraffic ? @"true" : @"false"] waitUntilDone:NO];
//        NSString* jsString = [NSString stringWithFormat:@
//                              "window.setTimeout(function() { \n"
//                              "setValue(%@,\"%@\",%@); \n"
//                              "},0.5);",responseNSString,timeType,isTraffic ? @"true" : @"false"];
//        
//        [ chart stringByEvaluatingJavaScriptFromString:jsString];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            NSMutableArray *dataSource = [[NSMutableArray alloc] init];
            
            NSString *_average,*unit=@"";
            NSInteger plotCount=0;
            float averageTraffic=0.0f;
            
            for(NSJSONSerialization *json in [responseJSON valueForKey:@"data"]){
                averageTraffic += [[json valueForKey:@"bytes"] floatValue];
                plotCount++;
            }
            averageTraffic /= plotCount;
            if((NSInteger)(averageTraffic/1073741824) != 0){
                _average = [NSString stringWithFormat:@"%1.2f %@",averageTraffic/1073741824,@"GigaBytes"];
            }
            else if((NSInteger)(averageTraffic / 1048576) != 0){
                _average = [NSString stringWithFormat:@"%1.2f %@",averageTraffic/1048576,@"MegaBytes"];
            }
            else if((NSInteger)(averageTraffic / 1024) != 0){
                _average = [NSString stringWithFormat:@"%1.2f %@",averageTraffic/1024,@"KiloBytes"];
            }
            else{
                _average = [NSString stringWithFormat:@"%1.2f %@",averageTraffic,@"Bytes"];
            }
            
            long long max=0;
            if(isTraffic){
                for(NSMutableDictionary *json in [responseJSON valueForKey:@"data"]){
                    [dataSource addObject: @{
                                             @"date":[ NSNumber numberWithLongLong:[[[json valueForKey:@"datetime"] valueForKey:@"sec"] longLongValue]*1000 ],
                                             @"traffic":[ NSNumber numberWithLongLong:[[json valueForKey:@"bytes"] longLongValue]],
                                             @"tag":[ NSNumber numberWithLongLong:[[[json valueForKey:@"datetime"] valueForKey:@"sec"] longLongValue]]
                                             }];
                    if(max < [[json valueForKey:@"bytes"] longLongValue])max = [[json valueForKey:@"bytes"] longLongValue];
                }
                
                long divide=1;
                if((NSInteger)(max / 1073741824) != 0){
                    divide = 1073741824;
                    unit = @"GB";
                }
                else if((NSInteger)(max / 1048576) != 0){
                    divide = 1048576;
                    unit = @"MB";
                }
                else if((NSInteger)(max / 1024) != 0){
                    divide = 1024;
                    unit = @"KB";
                }
                else{
                    unit = @"B";
                }
                
                for(NSInteger i=0;i<[dataSource count];i++){
                    NSJSONSerialization *json= [dataSource objectAtIndex:i];
                    [dataSource replaceObjectAtIndex:i withObject:@{
                                                                    @"date":[ NSNumber numberWithLongLong:[[json valueForKey:@"date"] longLongValue]],
                                                                    @"traffic":[ NSNumber numberWithDouble:[[json valueForKey:@"traffic"] doubleValue]/divide],
                                                                    @"tag":[ NSNumber numberWithLongLong:[[json valueForKey:@"tag"] longLongValue]]
                                                                    }];
                }

            }
            else{
                for(NSMutableDictionary *json in [responseJSON valueForKey:@"data"]){
                    [dataSource addObject: @{
                                             @"date":[ NSNumber numberWithLongLong:[[[json valueForKey:@"datetime"] valueForKey:@"sec"] longLongValue]*1000 ],
                                             @"deviceCount":[ NSNumber numberWithLongLong:[[json valueForKey:@"user_count"] intValue] ],
                                             @"tag":[ NSNumber numberWithLongLong:[[[json valueForKey:@"datetime"] valueForKey:@"sec"] longLongValue]]
                                             }];
                }
            }
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataSource
                                                               options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                                 error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                
                if (jsonData) {
                    average.text = _average;
                    
                    [ chart stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setValue(%@,\"%@\",\"%@\",%@)", jsonString,unit,timeType,isTraffic ? @"true" : @"false"]];
                }
                [DejalBezelActivityView removeViewAnimated:YES];
            });
        });
    };
    
    [unifiSystemResource getTrafficReport:completeCallback withHandleError:handleError fromStartTime:[[NSDate date] timeIntervalSince1970]+time andType:timeType];
    
    NSDate *today = [NSDate dateWithTimeIntervalSince1970:[[NSDate date] timeIntervalSince1970]+time];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSBuddhistCalendar];
    dateFormat.calendar = calendar;
    if([timeType isEqualToString:@"hourly"])[dateFormat setDateFormat:@"dd/MM/yyyy"];
    else [dateFormat setDateFormat:@"MM/yyyy"];
    
    NSString *dateString = [dateFormat stringFromDate:today];
    date.text = dateString;
    
}

-(void)showUser:(NSString *)clickedTime{
    NSLog(@"%@",clickedTime);
    contentSize = 5;
    
    [scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [DejalBezelActivityView currentActivityView].showNetworkActivityIndicator = YES;
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading."];
    [unifiSystemResource
         getTrafficUserReport:^(NSJSONSerialization *responseJSON,NSString *responseString){
             if(coverView.alpha==1)coverView.alpha=0;
             if(responseJSON != nil){
                 if([[responseJSON valueForKey:@"code"] intValue] == 200){
                     unifiTableList *authList = [[unifiTableList alloc] initWithFrame:CGRectMake(10, 7, 300, 0)];
                     authList.userInteractionEnabled=YES;
                     authList.header.text = @"Authorize Users";
                     authList.firstColumn.text = @"Hostname";
                     authList.secondColumn.text= @"Usage";
                     authList.firstColumnSize = authList.firstColumnSize+30;
                     authList.secondColumnX = authList.secondColumnX+15;
                     
                     unifiTableList *noAuthList = [[unifiTableList alloc] initWithFrame:CGRectMake(10,0,300,0)];
                     noAuthList.userInteractionEnabled=YES;
                     noAuthList.header.text = @"Pending Device";
                     noAuthList.firstColumn.text=@"Hostname";
                     noAuthList.secondColumn.text=@"Usage";
                     noAuthList.firstColumnSize = noAuthList.firstColumnSize+30;
                     noAuthList.secondColumnX = noAuthList.secondColumnX+15;
                     
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
                             
                             [authList addRowWithSubjectView:name andFirstColumnView:hostname andSecondColumnView:usage];

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
                             
                             [noAuthList addRowWithSubjectString:@"Unknown" andFirstColumnView:hostname andSecondColumnView:usage];
                         
                         }
                     }
                     
                    noAuthList.frame = CGRectMake(10, authList.contentSize+12, noAuthList.frame.size.width, noAuthList.frame.size.height);
                    [scrollView addSubview:authList];
                    [scrollView addSubview:noAuthList];
                    [scrollView setContentSize:CGSizeMake(300, noAuthList.contentSize + noAuthList.frame.origin.y+30)];
                 }
                 else{
                     UILabel *describe = [[UILabel alloc] initWithFrame:CGRectMake(75, 100, 250, 21)];
                     [describe setTextColor:[UIColor colorWithRed:0.663 green:0.639 blue:0.671 alpha:1.0]];
                     [describe setTextAlignment:NSTextAlignmentLeft];
                     [describe setFont:[UIFont systemFontOfSize:12]];
                     [describe setText:@"No device connect at this time"];
                     
                     [scrollView addSubview:describe];
                 }
             }
             [DejalBezelActivityView removeViewAnimated:YES];
         }
         withHandleError:handleError
         fromStartTime:[clickedTime doubleValue] andType:timeType
    ];
    

//    for(NSJSONSerialization *json in [statistic valueForKey:@"data"]){
//
//        if([[json valueForKey:@"_id"] isEqualToString:id]){
//            [DejalBezelActivityView currentActivityView].showNetworkActivityIndicator = YES;
//            [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading."];
//            if([[json valueForKey:@"guest_macs"] count]>0){
//                [unifiUserResource
//                    getUser:^(NSJSONSerialization *responseJSON,NSString *responseString){
//                        if(coverView.alpha==1)coverView.alpha=0;
//                        if(responseJSON != nil){
//                            if([[responseJSON valueForKey:@"code"] intValue] == 200){
//                                NSLog(@"%@",responseJSON);
//                                for(NSJSONSerialization *json in [responseJSON valueForKey:@"data"]){
//                                    if([ json valueForKey:@"google_id"] == nil)continue;
//                                
//                                    UILabel *describe,*hostname;
//                                    describe = [[UILabel alloc] initWithFrame:CGRectMake(11, contentSize, 185, 21)];
//                                    hostname = [[UILabel alloc] initWithFrame:CGRectMake(204, contentSize, 103, 21)];
//                    
//                                    [describe setTextColor:[UIColor colorWithRed:0.663 green:0.639 blue:0.671 alpha:1.0]];
//                                    [describe setTextAlignment:NSTextAlignmentLeft];
//                                    [describe setFont:[UIFont systemFontOfSize:11]];
//                                
//                                    NSString *describeStr = [NSString stringWithFormat:@"%@ %@",[json valueForKey:@"fname"],[json valueForKey:@"lname"]];
//                                    if([describeStr isEqualToString:@"- -"]){
//                                   
//                                        [describe setText:[json valueForKey:@"email"]];
//                                    }
//                                    else{
//                                        [describe setText:describeStr];
//                                    }
//                                
//                                
//                                    [hostname setTextColor:[UIColor colorWithRed:0.663 green:0.639 blue:0.671 alpha:1.0]];
//                                    [hostname setTextAlignment:NSTextAlignmentLeft];
//                                    [hostname setFont:[UIFont systemFontOfSize:11]];
//                                    if([json valueForKey:@"hostname"] != NULL) [hostname setText:[json valueForKey:@"hostname"]];
//                                    else [hostname setText:[json valueForKey:@"mac"]];
//                                
//                                    [scrollView addSubview:describe];
//                                    [scrollView addSubview:hostname];
//                                
//                                    unifiUITapGestureRecognizer* describeGesture = [[unifiUITapGestureRecognizer alloc] initWithTarget:self action:@selector(describeTapped:)];
//                                    // if labelView is not set userInteractionEnabled, you must do so
//                                    [describeGesture initParameter];
//                                    [describeGesture setParameter:[json valueForKey:@"google_id"] withKey:@"google_id"];
//                                    [describe setUserInteractionEnabled:YES];
//                                    [describe addGestureRecognizer:describeGesture];
//                                
//                                    unifiUITapGestureRecognizer* hostnameGesture = [[unifiUITapGestureRecognizer alloc] initWithTarget:self action:@selector(hostnameTapped:)];
//                                    // if labelView is not set userInteractionEnabled, you must do so
//                                    [hostnameGesture initParameter];
//                                    [hostnameGesture setParameter:[json valueForKey:@"mac"] withKey:@"mac"];
//                                    [hostname setUserInteractionEnabled:YES];
//                                    [hostname addGestureRecognizer:hostnameGesture];
//                                
//                                    contentSize+=20;
//                                    [scrollView setContentSize:CGSizeMake(68, contentSize)];
//                                    
//                                }
//                            }
//                            else{
//                                UILabel *describe = [[UILabel alloc] initWithFrame:CGRectMake(75, 100, 250, 21)];
//                                [describe setTextColor:[UIColor colorWithRed:0.663 green:0.639 blue:0.671 alpha:1.0]];
//                                [describe setTextAlignment:NSTextAlignmentLeft];
//                                [describe setFont:[UIFont systemFontOfSize:12]];
//                                [describe setText:@"No device connect at this time"];
//                                
//                                [scrollView addSubview:describe];
//                            }
//                        }
//                    [DejalBezelActivityView removeViewAnimated:YES];
//                    }
//                    withHandleError:^(NSError *error) {
//                        [DejalBezelActivityView removeViewAnimated:YES];
//                    }
//                    fromMac:[json valueForKey:@"guest_macs"]
//                ];
//            }
//            else{
//                if(coverView.alpha==1)coverView.alpha=0;
//                UILabel *describe = [[UILabel alloc] initWithFrame:CGRectMake(75, 100, 250, 21)];
//                [describe setTextColor:[UIColor colorWithRed:0.663 green:0.639 blue:0.671 alpha:1.0]];
//                [describe setTextAlignment:NSTextAlignmentLeft];
//                [describe setFont:[UIFont systemFontOfSize:12]];
//                [describe setText:@"No device connect at this time"];
//                
//                [scrollView addSubview:describe];
//                [DejalBezelActivityView removeViewAnimated:YES withDelay:0.5];
//            }
//        }
//    }
}

-(void) swipeRight:(UISwipeGestureRecognizer *) recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        if([timeType isEqualToString:@"hourly"]){
            time -= 60*60*7;
        }
        else{
            time -= 60*60*24*7;
        }
        [self showGraph];
        NSLog(@"Swipe Right");
    }
}

-(void) swipeLeft:(UISwipeGestureRecognizer *) recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        if([timeType isEqualToString:@"hourly"]){
            if([[NSDate date] timeIntervalSince1970]+(time+60*60*7) <= [[NSDate date] timeIntervalSince1970]) {time += 60*60*7;[self showGraph];}
            
        }
        else{
            if([[NSDate date] timeIntervalSince1970]+(time+60*60*24*7) <= [[NSDate date] timeIntervalSince1970]) {time += 60*60*24*7;[self showGraph];}
        }
        
        NSLog(@"Swipe Left");
    }

}
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


-(IBAction)backToParent:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)backToHome:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(IBAction)toggleTimeType:(id)sender{
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
-(IBAction)toggleChartType:(id)sender{
    if(isTraffic){
        [UIView
            animateWithDuration:0.3
            delay:0.0  /* do not add a delay because we will use performSelector. */
            options:UIViewAnimationOptionCurveEaseOut
            animations:^ {
                chartType.center = CGPointMake(360, 44);
            }
            completion:^(BOOL finished) {
                [chartType setTitle:@"Count" forState:UIControlStateNormal];
                [UIView
                    animateWithDuration:0.3
                    delay:0.0  /* do not add a delay because we will use performSelector. */
                    options:UIViewAnimationOptionCurveEaseOut
                    animations:^ {
                        chartType.center = CGPointMake(285, 44);
                    }
                    completion:^(BOOL finished) {
                    }
                 ];
            }
         ];
        
        isTraffic=!isTraffic;
        [self showGraph];
    }
    else{
        [UIView
             animateWithDuration:0.3
             delay:0.0  /* do not add a delay because we will use performSelector. */
             options:UIViewAnimationOptionCurveEaseOut
             animations:^ {
                 chartType.center = CGPointMake(360, 44);
             }
             completion:^(BOOL finished) {
                 [chartType setTitle:@"Traffic" forState:UIControlStateNormal];
                 [UIView
                      animateWithDuration:0.3
                      delay:0.1  /* do not add a delay because we will use performSelector. */
                      options:UIViewAnimationOptionCurveEaseOut
                      animations:^ {
                          chartType.center = CGPointMake(285, 44);
                      }
                      completion:^(BOOL finished) {
                      }
                  ];
             }
         ];
         isTraffic=!isTraffic;
        [self showGraph];
    }
    
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
