//
//  unifiApProfileViewController.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 2/11/2557 BE.
//  Copyright (c) 2557 KMUTNB. All rights reserved.
//

#import "unifiApProfileViewController.h"
#import "DejalActivityView.h"
#import "unifiApResource.h"
#import "unifiFailureViewController.h"
#import "unifiTableList.h"
#import "unifiUITapGestureRecognizer.h"
#import "unifiUserProfileViewController.h"
#import "unifiDeviceProfileViewController.h"

@interface unifiApProfileViewController ()

@end

@implementation unifiApProfileViewController{
    UITextField *apNameField;
    NSJSONSerialization *apData;
    ApiErrorCallback handleError;
}
@synthesize mac,apImage,header,version,serial,ip,userCount,upTime,deviceScrollView;
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
    __weak typeof (self) weakSelf = self;
    handleError= ^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:YES];
        unifiFailureViewController *failureController = [[weakSelf storyboard] instantiateViewControllerWithIdentifier:@"unifiFailureViewController"];
         //failureController.delegate = weakSelf;
        [[weakSelf navigationController] presentViewController:failureController animated:YES completion:nil];
    };
    [self initialize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initialize{
    [DejalBezelActivityView currentActivityView].showNetworkActivityIndicator = YES;
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"loading."];
    [self loadApData];
}
-(void)loadApData{
    
    [unifiApResource getAp:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
        if([[responseJSON valueForKey:@"code"] intValue] == 200){
            apData = [responseJSON valueForKey:@"data"];
            
            if([[apData valueForKey:@"state"] intValue] == 1){
                apImage.image = [UIImage imageNamed:@"UnifiOnlineIcon"];
                userCount.text = [NSString stringWithFormat:@"%i",[[apData valueForKey:@"num_sta"] intValue]];
            }
            else {
                apImage.image = [UIImage imageNamed:@"UnifiOfflineIcon"];
                userCount.text = [NSString stringWithFormat:@"%i",0];
            }
            header.text = [apData valueForKey:@"name"];
            ip.text = [apData valueForKey:@"ip"];
            version.text = [apData valueForKey:@"version"];
            serial.text = [apData valueForKey:@"serial"];
            
            NSInteger days = ([[apData valueForKey:@"uptime"] intValue] / 60 / 60 / 24);
            NSInteger hours = ([[apData valueForKey:@"uptime"] intValue] / 60 / 60);
            NSInteger minutes = ([[apData valueForKey:@"uptime"] intValue] / 60);
            NSInteger seconds = ([[apData valueForKey:@"uptime"] intValue]);
            
            if(days > 0){
                upTime.text = [NSString stringWithFormat:@"%i d %i h %i m %i s",days,hours%24,minutes%60,seconds%60];
            }
            else if (hours > 0){
                upTime.text = [NSString stringWithFormat:@"%i h %i m %i s",hours,minutes%60,seconds%60];
            }
            else if (minutes > 0){
                upTime.text = [NSString stringWithFormat:@"%i m %i s",minutes,seconds%60];
            }
            else if (seconds > 0){
                upTime.text = [NSString stringWithFormat:@"%i s",seconds];
            }
            [DejalBezelActivityView removeViewAnimated:YES];
        }
        
    } withHandleError:handleError fromMac:mac];
    
    [unifiApResource getDevice:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
        deviceScrollView.contentSize = CGSizeMake(0, 0);
        if([[responseJSON valueForKey:@"code"] intValue] ==200 || [[responseJSON valueForKey:@"code"] intValue] ==204){
            unifiTableList *authList = [[unifiTableList alloc] initWithFrame:CGRectMake(10, 5, 300, 0)];
            authList.header.text = @"Authorized Device";
            authList.firstColumn.text=@"Hostname";
            authList.secondColumn.text=@"Usage";
            if([[[responseJSON valueForKey:@"data"] valueForKey:@"auth"] count]>0)
                for(NSJSONSerialization *json in [[responseJSON valueForKey:@"data"] valueForKey:@"auth"]){
                    
                    UILabel *username ;
                    if([json valueForKey:@"name"] == [NSNull null])
                        username = [unifiTableList generateUILabelWithTitle:[json valueForKey:@"email"]];
                    else
                        username = [unifiTableList generateUILabelWithTitle:[json valueForKey:@"name"]];
                    
                    UILabel *hostname ;
                    if([json valueForKey:@"hostname"] != [NSNull null])
                        hostname = [unifiTableList generateUILabelWithTitle:[json valueForKey:@"hostname"]];
                    else
                        hostname = [unifiTableList generateUILabelWithTitle:[json valueForKey:@"mac"]];
                    
                    UIButton *traffic = [unifiTableList generateUIButtonWithTitle:[self getValueWithUnit:[[json valueForKey:@"bytes"] intValue]]];
                    [traffic setTitleColor:[UIColor colorWithRed:0.106 green:0.718 blue:0.651 alpha:1.0] forState:UIControlStateNormal];
                    traffic.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                    
                    
                    unifiUITapGestureRecognizer* usernameGesture = [[unifiUITapGestureRecognizer alloc] initWithTarget:self action:@selector(usernameTapped:)];
                    // if labelView is not set userInteractionEnabled, you must do so
                    [usernameGesture initParameter];
                    [usernameGesture setParameter:[json valueForKey:@"google_id"] withKey:@"google_id"];
                    [username setUserInteractionEnabled:YES];
                    [username addGestureRecognizer:usernameGesture];
                    
                    unifiUITapGestureRecognizer* hostnameGesture = [[unifiUITapGestureRecognizer alloc] initWithTarget:self action:@selector(hostnameTapped:)];
                    // if labelView is not set userInteractionEnabled, you must do so
                    [hostnameGesture initParameter];
                    [hostnameGesture setParameter:[json valueForKey:@"mac"] withKey:@"mac"];
                    [hostname setUserInteractionEnabled:YES];
                    [hostname addGestureRecognizer:hostnameGesture];
                    
                    [authList addRowWithSubjectView:username andFirstColumnView:hostname andSecondColumnView:traffic];
                    
                }
            else
                [authList addRowWithSubjectString:@"No Device" andFirstColumnView:nil andSecondColumnView:nil];

            unifiTableList *noAuthList = [[unifiTableList alloc] initWithFrame:CGRectMake(10, authList.contentSize+12, 300, 0)];
            noAuthList.header.text = @"Pending Device";
            noAuthList.firstColumn.text=@"Hostname";
            noAuthList.secondColumn.text=@"Usage";
            if([[[responseJSON valueForKey:@"data"] valueForKey:@"not_auth"] count]>0)
                for(NSJSONSerialization *json in [[responseJSON valueForKey:@"data"] valueForKey:@"not_auth"]){
                    
                    UILabel *hostname ;
                    if([json valueForKey:@"hostname"] != [NSNull null])
                        hostname = [unifiTableList generateUILabelWithTitle:[json valueForKey:@"hostname"]];
                    else
                        hostname = [unifiTableList generateUILabelWithTitle:[json valueForKey:@"mac"]];
                    
                    UIButton *traffic = [unifiTableList generateUIButtonWithTitle:[self getValueWithUnit:[[json valueForKey:@"bytes"] intValue]]];
                    [traffic setTitleColor:[UIColor colorWithRed:0.106 green:0.718 blue:0.651 alpha:1.0] forState:UIControlStateNormal];
                    traffic.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                    
                    unifiUITapGestureRecognizer* hostnameGesture = [[unifiUITapGestureRecognizer alloc] initWithTarget:self action:@selector(hostnameTapped:)];
                    // if labelView is not set userInteractionEnabled, you must do so
                    [hostnameGesture initParameter];
                    [hostnameGesture setParameter:[json valueForKey:@"mac"] withKey:@"mac"];
                    [hostname setUserInteractionEnabled:YES];
                    [hostname addGestureRecognizer:hostnameGesture];
                    
                    [noAuthList addRowWithSubjectString:@"Unknown" andFirstColumnView:hostname andSecondColumnView:traffic];
                
                }
            else
                [noAuthList addRowWithSubjectString:@"No Device" andFirstColumnView:nil andSecondColumnView:nil];
            
            [deviceScrollView addSubview:authList];
            [deviceScrollView addSubview:noAuthList];
            [deviceScrollView setContentSize:CGSizeMake(300, noAuthList.contentSize + noAuthList.frame.origin.y+30)];
        }
    } withHandleError:handleError fromApMac:mac];
}
-(IBAction)backToParent:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)restartAp:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Restart Alert!"
                          message:@"Do you really want to restart this access point?"
                          delegate:self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"Continue", nil ];
    [alert setTag:98];
    [alert show];
}
-(IBAction)editApName:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Edit Access Point Name"
                          message:nil
                          delegate:self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"Continue", nil ];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    apNameField = [alert textFieldAtIndex:0];
    apNameField.keyboardType = UIKeyboardTypeAlphabet;
    apNameField.text = [apData valueForKey:@"name"];
    [alert setTag:99];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( alertView.tag == 98){
        if (buttonIndex != 0){
            [DejalBezelActivityView currentActivityView].showNetworkActivityIndicator = YES;
            [DejalBezelActivityView activityViewForView:self.view withLabel:@"Sending..."];
            [unifiApResource
                restartAp:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
                    NSLog(@"%@",responseNSString);
                    if([[responseJSON valueForKey:@"code"] intValue] == 200){
                        [self loadApData];
                    }
                    else{
                        [DejalBezelActivityView removeViewAnimated:YES];
                        UIAlertView *alert = [[UIAlertView alloc]
                                              initWithTitle:@"Can not restart access point at this time."
                                              message:nil
                                              delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil ];
                        [alert show];
                        
                    }
                }
                withHandleError:handleError
                fromMac:[apData valueForKey:@"mac"]
             ];

        }
    }
    else{
        if (buttonIndex != 0){
            [DejalBezelActivityView currentActivityView].showNetworkActivityIndicator = YES;
            [DejalBezelActivityView activityViewForView:self.view withLabel:@"Sending..."];
            
            [unifiApResource
                setApName:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
                    if([[responseJSON valueForKey:@"code"] intValue] == 200){
                        [self loadApData];
                    }
                    else{
                        [DejalBezelActivityView removeViewAnimated:YES];
                        UIAlertView *alert = [[UIAlertView alloc]
                                              initWithTitle:@"Can not change access point name at this time."
                                              message:nil
                                              delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil ];
                        [alert show];

                    }
                }
                withHandleError:handleError
                withName:apNameField.text
                fromId:[apData valueForKey:@"_id"]
             ];
            
//        [NSTimer scheduledTimerWithTimeInterval:0.1f
//                                         target:self
//                                       selector:@selector(setDataTimer:)
//                                       userInfo:nil
//                                        repeats:NO];
        }
    }
}

-(void)usernameTapped:(unifiUITapGestureRecognizer*)gestureRecognizer{
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
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleBlackTranslucent;
}
@end
