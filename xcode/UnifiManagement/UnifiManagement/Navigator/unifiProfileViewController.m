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
    
    if([userData valueForKey:@"picture"] != [NSNull null]){
        [profilePicture setImageWithURL:[NSURL URLWithString:[userData valueForKey:@"picture"]] placeholderImage:[UIImage imageNamed:@"profile.jpg"] options:SDWebImageRefreshCached];
    }
    else [profilePicture setImage:[UIImage imageNamed:@"profile.jpg"]];
    
    [unifiDeviceResource
        getAuthorizedDevice:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
            onlineDevice  = [[responseJSON valueForKey:@"data"] valueForKey:@"online"];
            offlineDevice = [[responseJSON valueForKey:@"data"] valueForKey:@"offline"];
            [deviceCount setText:[NSString stringWithFormat:@"%i",[onlineDevice count]+[offlineDevice count]]];
        
            [self loadDevice];
        }
        withHandleError:^(NSError *error) {
            [DejalBezelActivityView removeViewAnimated:YES];
        }
        fromGoogleId:[userData valueForKey:@"google_id"]
     ];
    
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
        UIImageView *status;
        status = [[UIImageView alloc] initWithFrame:CGRectMake(10, contentSize+7, 8, 8)];
        status.image =[UIImage imageNamed:@"Dotted.png"];
        
        hostname = [[UILabel alloc] initWithFrame:CGRectMake(24, contentSize, 121, 21)];
        
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
        
    
        [scrollView addSubview:status];
        [scrollView addSubview:hostname];
        [scrollView addSubview:dateStart];

        
        [scrollView setContentSize:CGSizeMake(320, contentSize)];
        index++;
    }
    for(NSJSONSerialization *json in offlineDevice){
        if([ json valueForKey:@"google_id"] == nil)continue;
        if(index>0)contentSize+=21;
        
        UILabel *hostname,*dateStart;
        UIImageView *status;
        status = [[UIImageView alloc] initWithFrame:CGRectMake(10, contentSize+7, 8, 8)];
        status.image =[UIImage imageNamed:@"DottedSelected.png"];
        
        hostname = [[UILabel alloc] initWithFrame:CGRectMake(24, contentSize, 121, 21)];
        
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
        
        [scrollView addSubview:status];
        [scrollView addSubview:hostname];
        [scrollView addSubview:dateStart];
        
        
        [scrollView setContentSize:CGSizeMake(68, contentSize)];
        index++;
    }
   
}
-(IBAction)addDevice:(id)sender{
   
//    CATransition* transition = [CATransition animation];
//    transition.duration = .25;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
//    transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
//    
//    
//    
//    [self.navigationController.view.layer addAnimation:transition
//                                                                forKey:kCATransition];
    self.navigationController.modalPresentationStyle = UIModalPresentationPageSheet;
    [[self navigationController] presentViewController:[[self storyboard] instantiateViewControllerWithIdentifier:@"unifiSelectDeviceViewController"] animated:YES completion:nil];
    //]
  //  self.modalPresentationStyle=

}
@end
