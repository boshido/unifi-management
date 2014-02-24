//
//  unifiDeviceProfileViewController.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 1/20/2557 BE.
//  Copyright (c) 2557 KMUTNB. All rights reserved.
//

#import "unifiDeviceProfileViewController.h"
#import "DejalActivityView.h"
#import "unifiDeviceResource.h"
#import "unifiFailureViewController.h"
#import "unifiDeviceHistoryViewController.h"
#import "unifiUserListViewController.h"

static NSInteger TimePlus = 60*60*24*5;

@interface unifiDeviceProfileViewController ()

@end

@implementation unifiDeviceProfileViewController{
    BOOL isFirstLoad;
    NSTimer *autoLoad;
    NSTimeInterval timeStart,timeEnd;
    ApiErrorCallback handleError;
}
@synthesize deviceData,hostname,mac,ip,wlan,group,download,upload,activity,signal,signalImg,deviceImg,deviceMac,statisticChart,blockBtn,statusImg,authorizeBtn;
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
   
    
    
    __weak typeof(self) weakSelf=self;
    handleError= ^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:YES];
        unifiFailureViewController *failureController = [[weakSelf storyboard] instantiateViewControllerWithIdentifier:@"unifiFailureViewController"];
        //failureController.delegate = weakSelf;
        [[weakSelf navigationController] presentViewController:failureController animated:YES completion:nil];
    };
    
}
- (void)viewDidAppear:(BOOL)animated{
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"devicetrafficchart" ofType:@"html"]]];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [statisticChart addGestureRecognizer:swipeLeft];
    swipeLeft.delegate = self;
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [statisticChart addGestureRecognizer:swipeRight];
    swipeRight.delegate = self;
    
    statisticChart.delegate = self;
    statisticChart.scrollView.scrollEnabled = NO;
    statisticChart.scrollView.bounces = NO;
    
    [statisticChart loadRequest:urlRequest];
}
- (void)initialize{
    isFirstLoad = true;
    timeStart = -TimePlus;
    timeEnd = 0;
    
    [DejalBezelActivityView currentActivityView].showNetworkActivityIndicator = YES;
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading."];
    [self loadDevice];
    [self dailyStatisticWithLoading:NO];
    //autoLoad = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(loadDevice) userInfo:nil repeats:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// ----------------------------------   API         ------------------------------------
-(void)loadDevice{
    [unifiDeviceResource
     getDevice:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            deviceData  = [responseJSON valueForKey:@"data"];
            NSString *_hostname,*_deviceImg,*_statusImg,*_download,*_upload,*_activity,*_ip,*_wlan,*_group,*_signal,*_signalImg;
            _hostname = [deviceData valueForKey:@"hostname"] == [NSNull null] ? @"No Hostname" : [deviceData valueForKey:@"hostname"];
            
            _group = [deviceData valueForKey:@"usergroup_name"];
            
            NSRange search = [_hostname rangeOfString:@"iphone" options:NSCaseInsensitiveSearch];
            if(search.location != NSNotFound)
                _deviceImg =@"Apple.png";
            else{
                search = [_hostname rangeOfString:@"ipad" options:NSCaseInsensitiveSearch];
                if(search.location != NSNotFound)
                    _deviceImg =@"Apple.png";
                else{
                    search = [_hostname  rangeOfString:@"android" options:NSCaseInsensitiveSearch];
                    if(search.location != NSNotFound)
                        _deviceImg =@"Android.png";
                    else{
                        search = [_hostname  rangeOfString:@"windows" options:NSCaseInsensitiveSearch];
                        if(search.location != NSNotFound)
                            _deviceImg =@"Windows.png";
                        else
                            _deviceImg =@"PC.png";
                    }
                }
            }
            
            if([[responseJSON valueForKey:@"code"] intValue] == 200){
                _statusImg = @"Dotted.png";
                
                _download =  [self getValueWithUnit:[[deviceData valueForKey:@"rx_bytes"] floatValue]];
                _upload = [self getValueWithUnit:[[deviceData valueForKey:@"tx_bytes"] floatValue]];
                _activity = [NSString stringWithFormat:@"%@/Sec",[self getValueWithUnit:[[deviceData valueForKey:@"bytes.r"] floatValue]]];
                _ip = [deviceData valueForKey:@"ip"];
                _wlan = [deviceData valueForKey:@"essid"];
                
                NSInteger quality;
                if([[deviceData valueForKey:@"signal"] intValue] <= -100)
                    quality=0;
                else if([[deviceData valueForKey:@"signal"] intValue] >= -50)quality = 100;
                else quality = 2 * ([[deviceData valueForKey:@"signal"] intValue] + 100);
                
                _signal = [NSString stringWithFormat:@"%i%%",quality];
                
                if(quality > 80)_signalImg = @"WirelessBest.png";
                else if(quality > 40)_signalImg = @"WirelessGood.png";
                else _signalImg = @"WirelessBad.png";
            }
            else{
                
                _statusImg = @"DottedSelected.png";
                _download = @"-";
                _upload = @"-";
                _activity = @"-";
                _ip = @"-";
                _wlan = @"-";
                _signal = @"-";
                _signalImg = @"WirelessWorst.png";
            }
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [deviceImg setImage:[UIImage imageNamed:_deviceImg]];
                hostname.text = _hostname;
                mac.text = [deviceData valueForKey:@"mac"];
                statusImg.image = [UIImage imageNamed:_statusImg];
                download.text = _download;
                upload.text = _upload;
                activity.text = _activity;
                ip.text = _ip;
                wlan.text = _wlan;
                group.text = _group;
                signal.text = _signal;
                signalImg.image = [UIImage imageNamed:_signalImg];
                if([[deviceData valueForKey:@"blocked"] boolValue]){
                    [blockBtn setSelected:YES];
                }
                if([[deviceData valueForKey:@"is_auth"] boolValue]){
                    [authorizeBtn setSelected:YES];
                }
                
                if(!isFirstLoad){
                    [DejalBezelActivityView removeViewAnimated:YES];
                }
                isFirstLoad=false;
            });
        });
        
         
     }
     withHandleError:handleError
     fromMac:deviceMac
     ];
}
-(void)dailyStatisticWithLoading:(bool)flag{
    if(flag){
        [DejalBezelActivityView currentActivityView].showNetworkActivityIndicator = YES;
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading."];
    }
    
    [unifiDeviceResource
         getDeviceDailyStatistic:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
             dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                 NSMutableArray *dataSource = [[NSMutableArray alloc] init];
                 long long max=0;
                 for(NSMutableDictionary *json in [responseJSON valueForKey:@"data"]){
                     [dataSource addObject: @{
                                              @"date":[ NSNumber numberWithLongLong:[[[json valueForKey:@"datetime"] valueForKey:@"sec"] longLongValue]*1000 ],
                                              @"download":[ NSNumber numberWithLongLong:[[json valueForKey:@"tx_bytes"] longLongValue]],
                                              @"upload":[ NSNumber numberWithLongLong:[[json valueForKey:@"rx_bytes"] longLongValue]]
                                              }];
                     if(max < [[json valueForKey:@"tx_bytes"] longLongValue])max = [[json valueForKey:@"tx_bytes"] longLongValue];
                     if(max < [[json valueForKey:@"rx_bytes"] longLongValue])max = [[json valueForKey:@"rx_bytes"] longLongValue];
                 }
                 
                 NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataSource
                                                                    options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                                      error:nil];
                 
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    if (jsonData) {
                        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                        [statisticChart stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setValue(%@,%lld)",jsonString,max]];
                    }
                    if(!isFirstLoad){
                        [DejalBezelActivityView removeViewAnimated:YES];
                    }
                    isFirstLoad=false;
                });
             });
         }
         withHandleError:handleError
         fromStartTime:[[NSDate date] timeIntervalSince1970]+timeStart
         fromEndTime:[[NSDate date] timeIntervalSince1970]+timeEnd
         withMac:deviceMac
    ];
}

// ----------------------------------   View        ------------------------------------

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
// ----------------------------------   Delegate    ------------------------------------


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    webView.alpha=1;
    [self initialize];
}

// ----------------------------------   Event    ------------------------------------
-(IBAction)backToParent:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)blockDevice:(id)sender{
    
    [DejalBezelActivityView currentActivityView].showNetworkActivityIndicator = YES;
    if(!blockBtn.isSelected){
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading."];
        [unifiDeviceResource
         blockDevice:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
             [blockBtn setSelected:YES];
             [self loadDevice];
         }
         withHandleError:handleError
         fromMac:deviceMac
         ];
    }
    else{
        [unifiDeviceResource
         unBlockDevice:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
             [blockBtn setSelected:NO];
             [self loadDevice];
         }
         withHandleError:handleError
         fromMac:deviceMac
         ];
    }
    
}

-(IBAction)authorizeDevice:(id)sender{
    
    if(!authorizeBtn.isSelected){
        unifiUserListViewController *userList = [self.storyboard instantiateViewControllerWithIdentifier:@"unifiUserListViewController"];
        userList.deviceMac = [deviceData valueForKey:@"mac"];
        userList.deviceHostname = [deviceData valueForKey:@"hostname"] == [NSNull null] ? @"" : [deviceData valueForKey:@"hostname"];
        [self.navigationController pushViewController:userList animated:YES];
    }
    else{
        [DejalBezelActivityView currentActivityView].showNetworkActivityIndicator = YES;
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading."];
        [unifiDeviceResource
         unAuthorizeDevice:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
             [authorizeBtn setSelected:NO];
             [self performSelector:@selector(loadDevice) withObject:Nil afterDelay:1.0f];
         }
         withHandleError:handleError
         fromMac:deviceMac
         ];
    }
    
}

-(IBAction)viewHistory:(id)sender
{
    unifiDeviceHistoryViewController *history = [self.storyboard instantiateViewControllerWithIdentifier:@"unifiDeviceHistoryViewController"];
    history.deviceMac=deviceMac;
    [self.navigationController pushViewController:history animated:YES ];
}

-(void) swipeRight:(UISwipeGestureRecognizer *) recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        timeEnd = timeStart-60*60*24*1;
        timeStart += -TimePlus-60*60*24*1;
        
        [self dailyStatisticWithLoading:YES];
        NSLog(@"Swipe Right");
    }
}

-(void) swipeLeft:(UISwipeGestureRecognizer *) recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        if([[NSDate date] timeIntervalSince1970]+timeEnd+TimePlus <= [[NSDate date] timeIntervalSince1970]){
            timeStart = timeEnd+60*60*24*1;
            timeEnd += TimePlus+60*60*24*1;
            [self dailyStatisticWithLoading:YES];
        }
        NSLog(@"Swipe Left");
    }
    
}

// ----------------------------------   Other       ------------------------------------

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleBlackTranslucent;
}
@end
