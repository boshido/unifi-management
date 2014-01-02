//
//  unifiProfileViewController.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 12/31/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import "unifiProfileViewController.h"
#import "unifiDeviceResource.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface unifiProfileViewController ()

@end

@implementation unifiProfileViewController
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
    
//    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(concurrentQueue, ^{
//        if([userData valueForKey:@"picture"] != NULL){
//            NSData *data;
//            data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[userData valueForKey:@"picture"]]];
//            profilePicture.image = [[UIImage alloc]initWithData:data ];
//            
//        }
//        else{
//            profilePicture.image = [UIImage imageNamed:@"profile.jpg"];
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//           
//        });
//    });

    [profilePicture setImageWithURL:[NSURL URLWithString:[userData valueForKey:@"picture"]] placeholderImage:[UIImage imageNamed:@"profile.jpg"]];
    
    [unifiDeviceResource getAuthorizedDevice:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
        onlineDevice  = [[responseJSON valueForKey:@"data"] valueForKey:@"online"];
        offlineDevice = [[responseJSON valueForKey:@"data"] valueForKey:@"offline"];
        [deviceCount setText:[NSString stringWithFormat:@"%i",[onlineDevice count]+[offlineDevice count]]];
        
        [self loadDevice];
    } withGoogleId:[userData valueForKey:@"google_id"]];
    
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
-(void)loadDevice{
    contentSize=5;
    NSInteger index=0;
    //for(int i=0;i<15;i++)
    for(NSJSONSerialization *json in onlineDevice){
        if([ json valueForKey:@"google_id"] == nil)continue;
        if(index>0)contentSize+=21;
        
        UILabel *hostname,*dateStart;
        hostname = [[UILabel alloc] initWithFrame:CGRectMake(20, contentSize, 125, 21)];
        
        [hostname setTextColor:[UIColor colorWithRed:0.663 green:0.639 blue:0.671 alpha:1.0]];
        [hostname setTextAlignment:NSTextAlignmentLeft];
        [hostname setFont:[UIFont systemFontOfSize:11]];
        
        if([json valueForKey:@"hostname"] != NULL) [hostname setText:[json valueForKey:@"hostname"]];
        else [hostname setText:[json valueForKey:@"mac"]];

        dateStart = [[UILabel alloc] initWithFrame:CGRectMake(190, contentSize, 120, 21)];
        
        [dateStart setTextColor:[UIColor colorWithRed:0.663 green:0.639 blue:0.671 alpha:1.0]];
        [dateStart setTextAlignment:NSTextAlignmentLeft];
        [dateStart setFont:[UIFont systemFontOfSize:11]];

        NSTimeInterval _interval=[[json valueForKey:@"start"] doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        
        [formatter setLocale:[NSLocale currentLocale]];
        [formatter setDateFormat:@"dd/MM/yyyy HH:mm"];
        
        [dateStart setText:[formatter stringFromDate:date]];
        
    
      
        [scrollView addSubview:hostname];
        [scrollView addSubview:dateStart];

        
        [scrollView setContentSize:CGSizeMake(68, contentSize)];
        index++;
    }
    for(NSJSONSerialization *json in offlineDevice){
        if([ json valueForKey:@"google_id"] == nil)continue;
        if(index>0)contentSize+=21;
        
        UILabel *hostname,*dateStart;
        hostname = [[UILabel alloc] initWithFrame:CGRectMake(20, contentSize, 125, 21)];
        
        [hostname setTextColor:[UIColor colorWithRed:0.663 green:0.639 blue:0.671 alpha:1.0]];
        [hostname setTextAlignment:NSTextAlignmentLeft];
        [hostname setFont:[UIFont systemFontOfSize:11]];
        
        if([json valueForKey:@"hostname"] != NULL) [hostname setText:[json valueForKey:@"hostname"]];
        else [hostname setText:[json valueForKey:@"mac"]];
        
        dateStart = [[UILabel alloc] initWithFrame:CGRectMake(190, contentSize, 120, 21)];
        
        [dateStart setTextColor:[UIColor colorWithRed:0.663 green:0.639 blue:0.671 alpha:1.0]];
        [dateStart setTextAlignment:NSTextAlignmentLeft];
        [dateStart setFont:[UIFont systemFontOfSize:11]];
        
        NSTimeInterval _interval=[[json valueForKey:@"start"] doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        
        [formatter setLocale:[NSLocale currentLocale]];
        [formatter setDateFormat:@"dd/MM/yyyy HH:mm"];
        
        [dateStart setText:[formatter stringFromDate:date]];
        
        
        
        [scrollView addSubview:hostname];
        [scrollView addSubview:dateStart];
        
        
        [scrollView setContentSize:CGSizeMake(68, contentSize)];
        index++;
    }
   
}
@end