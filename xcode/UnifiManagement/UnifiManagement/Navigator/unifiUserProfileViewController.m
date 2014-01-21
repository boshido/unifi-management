//
//  unifiProfileViewController.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 12/31/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import "unifiUserProfileViewController.h"
#import "unifiDeviceResource.h"
#import "DejalActivityView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "unifiSelectDeviceViewController.h"
#import "unifiUITapGestureRecognizer.h"
#import "unifiDeviceProfileViewController.h"

@interface unifiUserProfileViewController ()

@end

@implementation unifiUserProfileViewController{
    NSString *markToDelete;
    ApiErrorCallback handleError;
}
@synthesize userData,profileView,typeBar,scrollView,profilePicture,profileEmail,profileName,deviceCount,onlineDevice,offlineDevice,googleId;
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
    
    bottomBorder.frame = CGRectMake(0.0f, typeBar.frame.size.height, typeBar.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:0.867 green:0.867 blue:0.867 alpha:1.0].CGColor;
    [typeBar.layer addSublayer:bottomBorder ];
    
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0.0f, 0.0f, typeBar.frame.size.width, 1.0f);
    topBorder.backgroundColor = [UIColor colorWithRed:0.867 green:0.867 blue:0.867 alpha:1.0].CGColor;
    [typeBar.layer addSublayer:topBorder];
    
    __weak typeof(self) weakSelf=self;
    handleError= ^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:YES];
        unifiFailureViewController *failureController = [[weakSelf storyboard] instantiateViewControllerWithIdentifier:@"unifiFailureViewController"];
        failureController.delegate = weakSelf;
        [[weakSelf navigationController] presentViewController:failureController animated:YES completion:nil];
    };

    
    
}
- (void)viewDidAppear:(BOOL)animated{
    [self initialize];
}
- (void)initialize{
    onlineDevice = [[NSMutableArray alloc] init];
    offlineDevice = [[NSMutableArray alloc] init];
    
    [profileName setText:[userData valueForKey:@"name"]];
    [profileEmail setText:[userData valueForKey:@"email"]];
    [profilePicture.layer setCornerRadius:45.0f];
    [profilePicture.layer setMasksToBounds: YES];
    // border
    [profilePicture.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [profilePicture.layer setBorderWidth:0.3f];
    
    if([userData valueForKey:@"picture"] != [NSNull null]){
        [profilePicture setImageWithURL:[NSURL URLWithString:[userData valueForKey:@"picture"]] placeholderImage:[UIImage imageNamed:@"profile.jpg"] options:SDWebImageRefreshCached];
    }
    else [profilePicture setImage:[UIImage imageNamed:@"profile.jpg"]];
    
    [DejalBezelActivityView currentActivityView].showNetworkActivityIndicator = YES;
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading."];
    [self loadDevice];
    
    [profilePicture.layer setCornerRadius:45.0f];
    [profilePicture.layer setMasksToBounds: YES];
    // border
    [profilePicture.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [profilePicture.layer setBorderWidth:0.3f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// ----------------------------------   API         ------------------------------------

-(void)loadDevice{
    [unifiDeviceResource
     getAuthorizedDevice:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
         onlineDevice  = [[responseJSON valueForKey:@"data"] valueForKey:@"online"];
         offlineDevice = [[responseJSON valueForKey:@"data"] valueForKey:@"offline"];
         
         [deviceCount setText:[NSString stringWithFormat:@"%i",[onlineDevice count]+[offlineDevice count]]];
         [DejalBezelActivityView removeViewAnimated:YES];
         
         [self displayDevice];
     }
     withHandleError:handleError
     fromGoogleId:[userData valueForKey:@"google_id"]
     ];
}

-(void)unAuthorize{
    [DejalBezelActivityView currentActivityView].showNetworkActivityIndicator = YES;
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading."];
    [unifiDeviceResource
     unAuthorizeDevice:^(NSJSONSerialization *responseJSON,NSString *reponseString){
         [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(loadDevice) userInfo:nil repeats:NO];
     }
     withHandleError:^(NSError *error) {
         [DejalBezelActivityView removeViewAnimated:YES];
         unifiFailureViewController *failureController = [[self storyboard] instantiateViewControllerWithIdentifier:@"unifiFailureViewController"];
         failureController.delegate = self;
         failureController.selector = @selector(unAuthorize);
         [[self navigationController] presentViewController:failureController animated:YES completion:nil];
     }
     fromMac:markToDelete
     ];
}

// ----------------------------------   View        ------------------------------------

-(void)displayDevice{
    NSLog(@"display Device");
    //    dateStart = [[UILabel alloc] initWithFrame:CGRectMake(190, contentSize, 120, 21)];
    //
    //    [dateStart setTextColor:[UIColor colorWithRed:0.663 green:0.639 blue:0.671 alpha:1.0]];
    //    [dateStart setTextAlignment:NSTextAlignmentLeft];
    //    [dateStart setFont:[UIFont systemFontOfSize:11]];
    //
    //    NSTimeInterval _interval=[[json valueForKey:@"start"] doubleValue];
    //    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    //    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    //
    //    [formatter setLocale:[NSLocale currentLocale]];
    //    [formatter setDateFormat:@"dd/MM/yyyy HH:mm"];
    //
    //    [dateStart setText:[formatter stringFromDate:date]];
    
    contentSize=5;
    NSInteger index=0;
    [scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for(NSMutableDictionary *json in onlineDevice){
        if([ json valueForKey:@"google_id"] == nil)continue;
        if(index>0)contentSize+=21;
        [self appendOnline:YES byDevice:json];
        index++;
    }
    for(NSMutableDictionary *json in offlineDevice){
        if([ json valueForKey:@"google_id"] == nil)continue;
        if(index>0)contentSize+=21;
        [self appendOnline:NO byDevice:json];
        index++;
    }
    
}

-(void)appendOnline:(bool)isOnline byDevice:(NSMutableDictionary*)json{
    
    UILabel *hostname,*download,*upload,*activity;
    UIImageView *status,*unAuthorize;
    status = [[UIImageView alloc] initWithFrame:CGRectMake(10, contentSize+7, 8, 8)];
    if(isOnline)
        status.image =[UIImage imageNamed:@"Dotted.png"];
    else
         status.image =[UIImage imageNamed:@"DottedSelected.png"];
    
    hostname = [[UILabel alloc] initWithFrame:CGRectMake(25, contentSize, 80, 21)];
    [hostname setTextColor:[UIColor colorWithRed:0.663 green:0.639 blue:0.671 alpha:1.0]];
    [hostname setTextAlignment:NSTextAlignmentLeft];
    [hostname setFont:[UIFont systemFontOfSize:11]];
    
    if([json valueForKey:@"hostname"] != NULL) [hostname setText:[json valueForKey:@"hostname"]];
    else [hostname setText:[json valueForKey:@"mac"]];
    
    unifiUITapGestureRecognizer* deviceProfile = [[unifiUITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDeviceProfile:)];
    // if labelView is not set userInteractionEnabled, you must do so
    [deviceProfile initParameter];
    [deviceProfile setParameter:[json valueForKey:@"mac"] withKey:@"mac"];
    [hostname setUserInteractionEnabled:YES];
    [hostname addGestureRecognizer:deviceProfile];

    
    download = [[UILabel alloc] initWithFrame:CGRectMake(115, contentSize, 50, 21)];
    [download setTextColor:[UIColor colorWithRed:0.663 green:0.639 blue:0.671 alpha:1.0]];
    [download setTextAlignment:NSTextAlignmentRight];
    [download setFont:[UIFont systemFontOfSize:11]];
    [download setText:[self getValueWithUnit:[[json valueForKey:@"tx_bytes"] floatValue]]];
    
    upload = [[UILabel alloc] initWithFrame:CGRectMake(170, contentSize, 50, 21)];
    [upload setTextColor:[UIColor colorWithRed:0.663 green:0.639 blue:0.671 alpha:1.0]];
    [upload setTextAlignment:NSTextAlignmentRight];
    [upload setFont:[UIFont systemFontOfSize:11]];
    [upload setText:[self getValueWithUnit:[[json valueForKey:@"rx_bytes"] floatValue]]];
    
    activity = [[UILabel alloc] initWithFrame:CGRectMake(225, contentSize, 70, 21)];
    [activity setTextColor:[UIColor colorWithRed:0.663 green:0.639 blue:0.671 alpha:1.0]];
    [activity setTextAlignment:NSTextAlignmentRight];
    [activity setFont:[UIFont systemFontOfSize:11]];
    [activity setText:[NSString stringWithFormat:@"%@/%@",[self getValueWithUnit:[[json valueForKey:@"bytes.r"] floatValue]],@"Sec"]];
    
    unAuthorize = [[UIImageView alloc] initWithFrame:CGRectMake(303, contentSize+6, 10, 10)];
    unAuthorize.image =[UIImage imageNamed:@"MiniCloseIcon.png"];
    
    unifiUITapGestureRecognizer* unAuthorizeGesture = [[unifiUITapGestureRecognizer alloc] initWithTarget:self action:@selector(unAuthorizeTapped:)];
    // if labelView is not set userInteractionEnabled, you must do so
    [unAuthorizeGesture initParameter];
    [unAuthorizeGesture setParameter:[json valueForKey:@"mac"] withKey:@"mac"];
    [unAuthorize setUserInteractionEnabled:YES];
    [unAuthorize addGestureRecognizer:unAuthorizeGesture];
    
    
    
    [scrollView addSubview:status];
    [scrollView addSubview:hostname];
    [scrollView addSubview:download];
    [scrollView addSubview:upload];
    [scrollView addSubview:activity];
    [scrollView addSubview:unAuthorize];
    [scrollView setContentSize:CGSizeMake(320, contentSize)];
}
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

- (void)unifiSelectDeviceView:(unifiSelectDeviceViewController *)viewController
              finishAddDevice:(BOOL)sign{
    [DejalBezelActivityView currentActivityView].showNetworkActivityIndicator = YES;
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading."];
    [self loadDevice];
}

- (void)failureView:(unifiFailureViewController *)viewController
       retryWithSel:(SEL)selector{
    if(selector != nil){
        IMP imp = [self methodForSelector:selector];
        void (*func)(id, SEL) = (void *)imp;
        func(self, selector);
    }
}

// ----------------------------------   Event       ------------------------------------

-(IBAction)backToParent:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)backToHome:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)addDevice:(id)sender{
    
    unifiSelectDeviceViewController *deviceController = [[self storyboard] instantiateViewControllerWithIdentifier:@"unifiSelectDeviceViewController"];
    deviceController.delegate = self;
    deviceController.userData = userData;
    [[self navigationController] presentViewController:deviceController animated:YES completion:nil];
    
}
-(void)unAuthorizeTapped:(unifiUITapGestureRecognizer*)gestureRecognizer{
    
    markToDelete = [gestureRecognizer getParameterByKey:@"mac"];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Comfirm Dialog"
                                                   message: @"Do you really want to Unauthorize"
                                                  delegate: self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"Yes",nil];
    [alert show];
    
}
-(void)showDeviceProfile:(unifiUITapGestureRecognizer*)gestureRecognizer{
    unifiDeviceProfileViewController *deviceProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"unifiDeviceProfileViewController"];
    deviceProfile.deviceMac = [gestureRecognizer getParameterByKey:@"mac"];
    
    [self.navigationController pushViewController:deviceProfile animated:YES];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        // Any action can be performed here
    }
    else
    {
        [self unAuthorize];
    }
}

// ----------------------------------   Other       ------------------------------------

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleBlackTranslucent;
}
@end
