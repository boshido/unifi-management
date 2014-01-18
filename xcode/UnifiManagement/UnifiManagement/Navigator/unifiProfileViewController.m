//
//  unifiProfileViewController.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 12/31/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import "unifiProfileViewController.h"
#import "unifiDeviceResource.h"
#import "DejalActivityView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "unifiSelectDeviceViewController.h"
#import "unifiUITapGestureRecognizer.h"

@interface unifiProfileViewController ()

@end

@implementation unifiProfileViewController{
    NSString *markToDelete;
}
@synthesize userData,profileView,typeBar,scrollView,profilePicture,profileEmail,profileName,deviceCount,onlineDevice,offlineDevice;
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
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleBlackTranslucent;
}

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
    self.navigationController.modalPresentationStyle = UIModalPresentationPageSheet;
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

-(void)loadDevice{
    [unifiDeviceResource
     getAuthorizedDevice:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
         onlineDevice  = [[responseJSON valueForKey:@"data"] valueForKey:@"online"];
         offlineDevice = [[responseJSON valueForKey:@"data"] valueForKey:@"offline"];
         NSLog(@"%@",onlineDevice);
         NSLog(@"%@",offlineDevice);
         
         [deviceCount setText:[NSString stringWithFormat:@"%i",[onlineDevice count]+[offlineDevice count]]];
         [DejalBezelActivityView removeViewAnimated:YES];
         
         [self displayDevice];
     }
     withHandleError:^(NSError *error) {
         [DejalBezelActivityView removeViewAnimated:YES];
     }
     fromGoogleId:[userData valueForKey:@"google_id"]
     ];
}
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
    
    download = [[UILabel alloc] initWithFrame:CGRectMake(115, contentSize, 50, 21)];
    [download setTextColor:[UIColor colorWithRed:0.663 green:0.639 blue:0.671 alpha:1.0]];
    [download setTextAlignment:NSTextAlignmentRight];
    [download setFont:[UIFont systemFontOfSize:11]];
    [download setText:@"1024 GB"];
    
    upload = [[UILabel alloc] initWithFrame:CGRectMake(170, contentSize, 50, 21)];
    [upload setTextColor:[UIColor colorWithRed:0.663 green:0.639 blue:0.671 alpha:1.0]];
    [upload setTextAlignment:NSTextAlignmentRight];
    [upload setFont:[UIFont systemFontOfSize:11]];
    [upload setText:@"1024 MB"];
    
    activity = [[UILabel alloc] initWithFrame:CGRectMake(225, contentSize, 70, 21)];
    [activity setTextColor:[UIColor colorWithRed:0.663 green:0.639 blue:0.671 alpha:1.0]];
    [activity setTextAlignment:NSTextAlignmentRight];
    [activity setFont:[UIFont systemFontOfSize:11]];
    [activity setText:@"1204 MB/Sec"];
    
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSLog(@"user pressed Button Indexed 0");
        // Any action can be performed here
    }
    else
    {
        [DejalBezelActivityView currentActivityView].showNetworkActivityIndicator = YES;
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading."];
        [unifiDeviceResource
         unAuthorizeDevice:^(NSJSONSerialization *responseJSON,NSString *reponseString){
             [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(loadDevice) userInfo:nil repeats:NO];
         }
         withHandleError:^(NSError *error) {
            [DejalBezelActivityView removeViewAnimated:YES];
         }
         fromMac:markToDelete
         ];

    }
}

- (void)unifiSelectDeviceView:(unifiSelectDeviceViewController *)viewController
              finishAddDevice:(BOOL)sign{
    [DejalBezelActivityView currentActivityView].showNetworkActivityIndicator = YES;
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading."];
    [self loadDevice];
}
@end
