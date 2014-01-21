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
static NSInteger TimePlus = 60*60*24*5;

@interface unifiDeviceProfileViewController ()

@end

@implementation unifiDeviceProfileViewController{
    BOOL isFirstLoad;
    NSTimer *autoLoad;
    NSTimeInterval timeStart,timeEnd;
    ApiErrorCallback handleError;
}
@synthesize hostname,mac,ip,wlan,download,upload,activity,signal,signalImg,deviceImg,deviceMac,statisticChart,blockBtn,statusImg,authorizeBtn;
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
    
    __weak typeof(self) weakSelf=self;
    handleError= ^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:YES];
        unifiFailureViewController *failureController = [[weakSelf storyboard] instantiateViewControllerWithIdentifier:@"unifiFailureViewController"];
        //failureController.delegate = weakSelf;
        [[weakSelf navigationController] presentViewController:failureController animated:YES completion:nil];
    };
    
}
- (void)initialize{
    isFirstLoad = true;
    timeStart = -TimePlus;
    timeEnd = 0;
    
    [DejalBezelActivityView currentActivityView].showNetworkActivityIndicator = YES;
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading."];
    [self loadDevice];
    [self dailyStatisticWithLoading:NO];
    autoLoad = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(loadDevice) userInfo:nil repeats:YES];
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
         NSJSONSerialization *json  = [responseJSON valueForKey:@"data"];
         hostname.text = [json valueForKey:@"hostname"];
         mac.text = [json valueForKey:@"mac"];
         
         if([[json valueForKey:@"blocked"] boolValue]){
             [blockBtn setSelected:YES];
         }
//         if([[json valueForKey:@"is_auth"] boolValue]){
//             [authorizeBtn setSelected:YES];
//         }
         NSRange search = [[json valueForKey:@"hostname"] rangeOfString:@"iphone" options:NSCaseInsensitiveSearch];
         if(search.location != NSNotFound)
             [deviceImg setImage:[UIImage imageNamed:@"Apple.png"]];
         else{
             search = [[json valueForKey:@"hostname"] rangeOfString:@"ipad" options:NSCaseInsensitiveSearch];
             if(search.location != NSNotFound)
                 [deviceImg setImage:[UIImage imageNamed:@"Apple.png"]];
             else{
                 search = [[json valueForKey:@"hostname"]  rangeOfString:@"android" options:NSCaseInsensitiveSearch];
                 if(search.location != NSNotFound)
                     [deviceImg setImage:[UIImage imageNamed:@"Android.png"]];
                 else{
                     search = [[json valueForKey:@"hostname"]  rangeOfString:@"windows" options:NSCaseInsensitiveSearch];
                     if(search.location != NSNotFound)
                         [deviceImg setImage:[UIImage imageNamed:@"Windows.png"]];
                     else
                         [deviceImg setImage:[UIImage imageNamed:@"PC.png"]];
                 }
             }
         }
         
         if([[responseJSON valueForKey:@"code"] intValue] == 200){
             statusImg.image = [UIImage imageNamed:@"Dotted.png"];
             
             download.text = [self getValueWithUnit:[[json valueForKey:@"rx_bytes"] floatValue]];
             upload.text = [self getValueWithUnit:[[json valueForKey:@"tx_bytes"] floatValue]];
             activity.text = [NSString stringWithFormat:@"%@/Sec",[self getValueWithUnit:[[json valueForKey:@"bytes.r"] floatValue]]];
             ip.text = [json valueForKey:@"ip"];
             wlan.text = [json valueForKey:@"essid"];
             
             NSInteger quality;
             if([[json valueForKey:@"signal"] intValue] <= -100)
                 quality=0;
             else if([[json valueForKey:@"signal"] intValue] >= -50)quality = 100;
             else quality = 2 * ([[json valueForKey:@"signal"] intValue] + 100);
             
             signal.text = [NSString stringWithFormat:@"%i%%",quality];
             
             if(quality > 80)signalImg.image = [UIImage imageNamed:@"WirelessBest.png"];
             else if(quality > 40)signalImg.image = [UIImage imageNamed:@"WirelessGood.png"];
             else signalImg.image = [UIImage imageNamed:@"WirelessBad.png"];
         }
         else{
             download.text = @"-";
             upload.text = @"-";
             activity.text = @"-";
             ip.text = @"-";
             wlan.text = @"-";
             signal.text = @"-";
             signalImg.image = [UIImage imageNamed:@"WirelessWorst.png"];
             
             statusImg.image = [UIImage imageNamed:@"DottedSelected.png"];
         
         }
         if(!isFirstLoad){
             [DejalBezelActivityView removeViewAnimated:YES];
         }
         isFirstLoad=false;
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
             [statisticChart stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setValue(%@)",responseNSString]];
             if(!isFirstLoad){
                 [DejalBezelActivityView removeViewAnimated:YES];
             }
             isFirstLoad=false;
         }
         withHandleError:handleError
         fromStartTime:[[NSDate date] timeIntervalSince1970]+timeStart
         fromEndTime:[[NSDate date] timeIntervalSince1970]+timeEnd
         withMac:deviceMac
    ];
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

// ----------------------------------   View        ------------------------------------

-(NSString *)getValueWithUnit:(float)value{
    if((NSInteger)(value/1073741824) != 0){
        value = value / 1073741824;
        return [NSString stringWithFormat:@"%0.0f %@",value,@"GB"];
    }
    else if((NSInteger)(value / 1048576) != 0){
        value = value / 1048576;
        return [NSString stringWithFormat:@"%0.0f %@",value,@"MB"];
    }
    else if((NSInteger)(value / 1024) != 0){
        value = value / 1024;
        return [NSString stringWithFormat:@"%0.0f %@",value,@"KB"];
    }
    else{
        return [NSString stringWithFormat:@"%0.0f %@",value,@"B"];
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
