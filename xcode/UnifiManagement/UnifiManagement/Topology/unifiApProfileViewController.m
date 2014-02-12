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
@interface unifiApProfileViewController ()

@end

@implementation unifiApProfileViewController{
    UITextField *apNameField;
    NSJSONSerialization *apData;
    ApiErrorCallback handleError;
}
@synthesize mac,apImage,header,ip,userCount,deviceScrollView;
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
    apNameField = [[UITextField alloc] init];
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
                userCount.text = [NSString stringWithFormat:@"User Count : %i",[[apData valueForKey:@"num_sta"] intValue]];
            }
            else {
                apImage.image = [UIImage imageNamed:@"UnifiOfflineIcon"];
                userCount.text = [NSString stringWithFormat:@"User Count : %i",0];
            }
            header.text = [apData valueForKey:@"name"];
            ip.text = [apData valueForKey:@"ip"];
            
            [DejalBezelActivityView removeViewAnimated:YES];
        }
        
    } withHandleError:handleError fromMac:mac];
    
    [unifiApResource getDevice:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
        deviceScrollView.contentSize = CGSizeMake(0, 0);
        NSInteger contentSize = 5;
        if([[responseJSON valueForKey:@"code"] intValue] ==200){
            for(NSJSONSerialization *json in [responseJSON valueForKey:@"data"]){
                UILabel *describe,*hostname;
                describe = [[UILabel alloc] initWithFrame:CGRectMake(11, contentSize, 130, 21)];
                hostname = [[UILabel alloc] initWithFrame:CGRectMake(144, contentSize, 103, 21)];
                
                [describe setTextColor:[UIColor colorWithRed:0.663 green:0.639 blue:0.671 alpha:1.0]];
                [describe setTextAlignment:NSTextAlignmentLeft];
                [describe setFont:[UIFont systemFontOfSize:11]];

                if([json valueForKey:@"name"] == [NSNull null]) [describe setText:[json valueForKey:@"email"]];
                else [describe setText:[json valueForKey:@"name"]];
                
                [hostname setTextColor:[UIColor colorWithRed:0.663 green:0.639 blue:0.671 alpha:1.0]];
                [hostname setTextAlignment:NSTextAlignmentLeft];
                [hostname setFont:[UIFont systemFontOfSize:11]];
                if([json valueForKey:@"hostname"] != [NSNull null]) [hostname setText:[json valueForKey:@"hostname"]];
                else [hostname setText:[json valueForKey:@"mac"]];
                
                [deviceScrollView addSubview:describe];
                [deviceScrollView addSubview:hostname];
                
                //                    unifiUITapGestureRecognizer* describeGesture = [[unifiUITapGestureRecognizer alloc] initWithTarget:self action:@selector(describeTapped:)];
                //                    // if labelView is not set userInteractionEnabled, you must do so
                //                    [describeGesture initParameter];
                //                    [describeGesture setParameter:[json valueForKey:@"google_id"] withKey:@"google_id"];
                //                    [describe setUserInteractionEnabled:YES];
                //                    [describe addGestureRecognizer:describeGesture];
                //
                //                    unifiUITapGestureRecognizer* hostnameGesture = [[unifiUITapGestureRecognizer alloc] initWithTarget:self action:@selector(hostnameTapped:)];
                //                    // if labelView is not set userInteractionEnabled, you must do so
                //                    [hostnameGesture initParameter];
                //                    [hostnameGesture setParameter:[json valueForKey:@"mac"] withKey:@"mac"];
                //                    [hostname setUserInteractionEnabled:YES];
                //                    [hostname addGestureRecognizer:hostnameGesture];
                contentSize+=20;
                [deviceScrollView setContentSize:CGSizeMake(68, contentSize)];
            }
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
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleBlackTranslucent;
}
@end
