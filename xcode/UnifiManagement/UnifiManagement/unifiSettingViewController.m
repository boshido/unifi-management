//
//  unifiSettingViewController.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 12/2/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import "unifiSettingViewController.h"
#import "unifiGlobalVariable.h"
#import "unifiApiConnector.h"
#import "unifiGoogleResource.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DejalActivityView.h"
#import "unifiSystemResource.h"
#import "unifiSettingsView.h"
#import "unifiButton.h"
#import "unifiAddBandwidthViewController.h"

@interface unifiSettingViewController ()

@end

@implementation unifiSettingViewController{
    UITextField *alertField;
    NSInteger groupIndex;
    ApiErrorCallback handleError;
}
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
    
    __weak typeof(self) weakSelf = self;
    handleError= ^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:YES];
        unifiFailureViewController *failureController = [[weakSelf storyboard] instantiateViewControllerWithIdentifier:@"unifiFailureViewController"];
        [weakSelf presentViewController:failureController animated:YES completion:nil];
    };
}
-(void)viewDidAppear:(BOOL)animated
{
    [self initialize];
}
-(void)initialize{
    spinner = [[TJSpinner alloc] initWithSpinnerType:kTJSpinnerTypeActivityIndicator];
    [spinner setColor:[UIColor colorWithRed:17/255.00 green:181/255.00 blue:255.00/255.00 alpha:1.0]];
    [spinner setStrokeWidth:20];
    [spinner setInnerRadius:6];
    [spinner setOuterRadius:15];
    [spinner setNumberOfStrokes:8];
    spinner.hidesWhenStopped = YES;
    [spinner setPatternStyle:TJActivityIndicatorPatternStylePetal];
    spinner.center = CGPointMake(62, 85);
    [spinner startAnimating];
    [self.view addSubview:spinner];
    // border radius
    [profilePicture.layer setCornerRadius:47.5f];
    [profilePicture.layer setMasksToBounds: YES];
    // border
    [profilePicture.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [profilePicture.layer setBorderWidth:0.3f];
    
    __weak typeof(profilePicture) profilePictureWeak = profilePicture;
    __weak typeof(spinner) spinnerWeak = spinner;
    
    name.text = [NSString stringWithFormat:@"%@ %@",[unifiGlobalVariable sharedGlobalData].name,[unifiGlobalVariable sharedGlobalData].surname];
    permission.text = [unifiGlobalVariable sharedGlobalData].permissionName;
    email.text  = [unifiGlobalVariable sharedGlobalData].email;
    [profilePicture setImageWithURL:[NSURL URLWithString:[ unifiGlobalVariable sharedGlobalData].profilePicture]
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                              
                              [UIView animateWithDuration:0.5
                                                    delay:0.0  /* do not add a delay because we will use performSelector. */
                                                  options:UIViewAnimationOptionCurveEaseOut
                                               animations:^ {
                                                   profilePictureWeak.alpha = 1.0;
                                               }
                                               completion:^(BOOL finished) {
                                                   // [myLabel1 removeFromSuperview];
                                               }];
                              
                              [spinnerWeak stopAnimating];
                          }
     ];
    [self loadSettingInfoWithLoading:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadSettingInfoWithLoading:(bool)loadingFlag{
    if(loadingFlag){
        [DejalBezelActivityView currentActivityView].showNetworkActivityIndicator = YES;
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading."];
    }
    [unifiSystemResource
        getSettingsInformation:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
            if([[responseJSON valueForKey:@"code"]intValue] == 200){
                [DejalBezelActivityView removeViewAnimated:YES];
                
                settingsData = [responseJSON valueForKey:@"data"];
                [scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                
                // General Settings
                unifiSettingsView *generalView = [[unifiSettingsView alloc] initWithFrame:CGRectMake(10, 10, 300, 0)];
                generalView.header.text = @"General Settings";
                generalView.firstColumn.text = @"Unit";
                generalView.secondColumn.text= @"Enabled";
                
                UIButton *notificationEnabled = [unifiSettingsView generateUIButtonWithTitle:[[[settingsData valueForKey:@"token"] valueForKey:@"enabled"] boolValue] ? @"On":@"Off"];
                [notificationEnabled addTarget:self action:@selector(setNotificationEnabled:) forControlEvents:UIControlEventTouchUpInside];
                [generalView addRowWithSubjectString:@"Push Notification" andFirstColumnView:nil andSecondColumnView:notificationEnabled];
                
                UIButton *loadMetric = [unifiSettingsView generateUIButtonWithTitle: [NSString stringWithFormat:@"%i per AP",[[[ settingsData valueForKey:@"load_balance"] valueForKey:@"max_sta"] intValue]]];
                [loadMetric addTarget:self action:@selector(setLoadMetric:) forControlEvents:UIControlEventTouchUpInside];
                
                UIButton *loadEnabled = [unifiSettingsView generateUIButtonWithTitle: [[[ settingsData valueForKey:@"load_balance"] valueForKey:@"enabled"] boolValue] ? @"On":@"Off"];
                [loadEnabled addTarget:self action:@selector(setLoadEnabled:) forControlEvents:UIControlEventTouchUpInside];
                [generalView addRowWithSubjectString:@"Users Load Balancing" andFirstColumnView:loadMetric andSecondColumnView:loadEnabled];
    
                [scrollView addSubview:generalView];
                
                // Bandwidth Group Settings
                unifiSettingsView *groupView = [[unifiSettingsView alloc] initWithFrame:CGRectMake(10, generalView.frame.size.height+5, 300, 0)];
                groupView.header.text = @"Bandwidth Groups";
                groupView.firstColumn.text = @"Down";
                groupView.secondColumn.text= @"Up";
                
                UIButton *addGroup = [unifiSettingsView generateAccessoryUIButtonWithImagedName:@"AddIcon.png"];
                addGroup.frame = CGRectMake(105, 0, 20, 20);
                [addGroup addTarget:self action:@selector(addGroup:) forControlEvents:UIControlEventTouchUpInside];
                [groupView addSubview:addGroup];
                
                NSUInteger index = 0;
                for(NSJSONSerialization *group in [settingsData valueForKey:@"usergroup"]){
                    NSString *downString,*upString;
                    
                    if([[group valueForKey:@"qos_rate_max_down"] intValue] >0 && [[group valueForKey:@"downRate_enabled"] boolValue])
                        downString = [NSString stringWithFormat:@"%0.0d KBps",[[group valueForKey:@"qos_rate_max_down"] intValue]/8];
                    else
                        downString = @"No Limit";
                    
                    if([[group valueForKey:@"qos_rate_max_up"] intValue] >0 && [[group valueForKey:@"upRate_enabled"] boolValue])
                        upString= [NSString stringWithFormat:@"%0.0d KBps",[[group valueForKey:@"qos_rate_max_up"] intValue]/8];
                    else
                        upString = @"No Limit";

                    
                    UIButton *nameButton = [unifiSettingsView generateUIButtonWithTitle:[group valueForKey:@"name"]];
                    nameButton.tag=index;
                    [nameButton setTitleColor:[UIColor colorWithRed:0.106 green:0.718 blue:0.651 alpha:1.0] forState:UIControlStateNormal];
                    nameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                    [nameButton addTarget:self action:@selector(addUserToGroup:) forControlEvents:UIControlEventTouchUpInside];
                    
                    UIButton *downButton = [unifiSettingsView generateUIButtonWithTitle:downString];
                    downButton.tag=index;
                    [downButton addTarget:self action:@selector(setGroupDownload:) forControlEvents:UIControlEventTouchUpInside];
                    
                    UIButton *upButton = [unifiSettingsView generateUIButtonWithTitle:upString];
                    upButton.tag=index;
                    [upButton addTarget:self action:@selector(setGroupUpload:) forControlEvents:UIControlEventTouchUpInside];
                    
                    NSLog(@"%i",groupView.contentSize);
                    UIButton *deleteGroup = [unifiSettingsView generateAccessoryUIButtonWithImagedName:@"DeleteIcon.png"];
                    deleteGroup.tag=index;
                    
                    if(![[group valueForKey:@"attr_no_delete"] boolValue]){
                        deleteGroup.frame = CGRectMake(280, groupView.contentSize, 20, 20);
                        [deleteGroup addTarget:self action:@selector(deleteGroup:) forControlEvents:UIControlEventTouchUpInside];
                        [groupView addSubview:deleteGroup];
                    }
                    
                    [groupView addRowWithSubjectView:nameButton andFirstColumnView:downButton  andSecondColumnView:upButton];
                    
//
//                    if([[group valueForKey:@"attr_no_delete"] boolValue]){ // Default Limit
//                        
//                        [groupView addRowWithSubjectString:[group valueForKey:@"name"] andFirstColumnView:downButton  andSecondColumnView:upButton];
//                    }
//                    else{ // Other Limit
//          
//                    }
//                    
                    index++;
                }
                [scrollView addSubview:groupView];
            }
        }
        withHandleError:handleError
        fromTokenId:@"27216b1263b9fa530b2033e6f1c83d3d23e312347ae5d68fef5b630ade49484f"
    ];
    NSLog(@"%@",[unifiGlobalVariable sharedGlobalData].iosToken);
}

-(IBAction)setNotificationEnabled:(id)sender{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Comfirm Dialog"
                                                   message: [NSString stringWithFormat:@"Do you really want to turn notification %@",[[[settingsData valueForKey:@"token"] valueForKey:@"enabled"] boolValue] ? @"off" : @"on"]
                                                  delegate: self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:[[[settingsData valueForKey:@"token"] valueForKey:@"enabled"] boolValue] ? @"Turn off" : @"Turn on",nil];
    
    alert.tag = 2;
    [alert show];
}

-(IBAction)setLoadMetric:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Users Load Banlancing"
                          message:@"Balance number of stations per radio"
                          delegate:self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"Continue", nil ];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertField = [alert textFieldAtIndex:0];
    alertField.keyboardType = UIKeyboardTypeNumberPad;
    alertField.text = [NSString stringWithFormat:@"%i",[[[ settingsData valueForKey:@"load_balance"] valueForKey:@"max_sta"] intValue]];
    [alert setTag:3];
    [alert show];

}

-(IBAction)setLoadEnabled:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Comfirm Dialog"
                                                   message: [NSString stringWithFormat:@"Do you really want to turn load banlancing %@",[[[settingsData valueForKey:@"load_balance"] valueForKey:@"enabled"] boolValue] ? @"off":@"on"]
                                                  delegate: self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:[[[settingsData valueForKey:@"load_balance"] valueForKey:@"enabled"] boolValue] ? @"Turn off" : @"Turn on" ,nil];
    
    alert.tag = 4;
    [alert show];
}

-(IBAction)addGroup:(id)sender{
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Create Usergroup"
                          message:@"Enter group name"
                          delegate:self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"Continue", nil ];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertField = [alert textFieldAtIndex:0];
    alertField.keyboardType = UIKeyboardTypeAlphabet;
    alertField.text = @"";
    
    [alert setTag:5];
    [alert show];
}

-(IBAction)setGroupDownload:(id)sender{
    UIButton *button = (UIButton *)sender;
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:[NSString stringWithFormat:@"Setting \"%@\" Group",[[[ settingsData valueForKey:@"usergroup"] objectAtIndex:button.tag] valueForKey:@"name"]]
                          message:@"Set 0 for no limit \nDownload (Maximum 12800 KBps)"
                          delegate:self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"Continue", nil ];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertField = [alert textFieldAtIndex:0];
    alertField.keyboardType = UIKeyboardTypeNumberPad;
    alertField.text = [NSString stringWithFormat:@"%i",[[[[ settingsData valueForKey:@"usergroup"] objectAtIndex:button.tag] valueForKey:@"qos_rate_max_down"] intValue]/8];
    groupIndex = button.tag;
    
    [alert setTag:6];
    [alert show];
    
}

-(IBAction)setGroupUpload:(id)sender{
    UIButton *button = (UIButton *)sender;
    
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:[NSString stringWithFormat:@"Setting \"%@\" Group",[[[ settingsData valueForKey:@"usergroup"] objectAtIndex:button.tag] valueForKey:@"name"]]
                          message:@"Set 0 for no limit \nUpload (Maximum 12800 KBps)"
                          delegate:self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"Continue", nil ];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertField = [alert textFieldAtIndex:0];
    alertField.keyboardType = UIKeyboardTypeNumberPad;
    alertField.text = [NSString stringWithFormat:@"%i",[[[[ settingsData valueForKey:@"usergroup"] objectAtIndex:button.tag] valueForKey:@"qos_rate_max_up"] intValue]/8];
    groupIndex = button.tag;
    
    [alert setTag:7];
    [alert show];
    
}

-(IBAction)deleteGroup:(id)sender{
     UIButton *button = (UIButton *)sender;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Comfirm Dialog"
                                                   message: [NSString stringWithFormat:@"Do you really want to delete %@ group",[[[ settingsData valueForKey:@"usergroup"] objectAtIndex:button.tag] valueForKey:@"name"]]
                                                  delegate: self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"Delete" ,nil];
    groupIndex = button.tag;
    
    alert.tag = 8;
    [alert show];
}
-(IBAction)addUserToGroup:(id)sender{
    UIButton *button = (UIButton *)sender;
    
    unifiAddBandwidthViewController *addBadwidth = [self.storyboard instantiateViewControllerWithIdentifier:@"unifiAddBandwidthViewController"];
    
    addBadwidth.groupData = [[ settingsData valueForKey:@"usergroup"] objectAtIndex:button.tag] ;

    
    [self.navigationController pushViewController:addBadwidth animated:YES];
}



//-(void)loadAlarm{
//    [unifiSystemResource
//        getAlarm:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
//            
//            if([[responseJSON valueForKey:@"code"] intValue] == 200){
//                NSInteger contentSize = 5;
//                for (NSJSONSerialization *json in [responseJSON valueForKey:@"data"]) {
//                    UILabel *describe = [[UILabel alloc] initWithFrame:CGRectMake(11, contentSize, 250, 21)];
//                    //hostname = [[UILabel alloc] initWithFrame:CGRectMake(144, contentSize, 103, 21)];
//                    
//                    [describe setTextColor:[UIColor colorWithRed:0.663 green:0.639 blue:0.671 alpha:1.0]];
//                    [describe setTextAlignment:NSTextAlignmentLeft];
//                    [describe setFont:[UIFont systemFontOfSize:11]];
//                    
//                    [describe setText:[json valueForKey:@"msg"]];
//                    
//                    [alarmView addSubview:describe];
//                    
//                    //                    unifiUITapGestureRecognizer* describeGesture = [[unifiUITapGestureRecognizer alloc] initWithTarget:self action:@selector(describeTapped:)];
//                    //                    // if labelView is not set userInteractionEnabled, you must do so
//                    //                    [describeGesture initParameter];
//                    //                    [describeGesture setParameter:[json valueForKey:@"google_id"] withKey:@"google_id"];
//                    //                    [describe setUserInteractionEnabled:YES];
//                    //                    [describe addGestureRecognizer:describeGesture];
//                    //
//                    //                    unifiUITapGestureRecognizer* hostnameGesture = [[unifiUITapGestureRecognizer alloc] initWithTarget:self action:@selector(hostnameTapped:)];
//                    //                    // if labelView is not set userInteractionEnabled, you must do so
//                    //                    [hostnameGesture initParameter];
//                    //                    [hostnameGesture setParameter:[json valueForKey:@"mac"] withKey:@"mac"];
//                    //                    [hostname setUserInteractionEnabled:YES];
//                    //                    [hostname addGestureRecognizer:hostnameGesture];
//                    contentSize+=20;
//                    
//                }
//            }
//        }
//        withHandleError:^(NSError *error) {
//        
//        }
//        withType:false fromStart:0 toLength:5
//     ];
//}
-(IBAction)signOut:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Comfirm Dialog"
                                                   message: @"Do you really want to signout"
                                                  delegate: self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"OK",nil];
    
    alert.tag = 1;
    [alert show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{   if(buttonIndex>0){
        [DejalBezelActivityView currentActivityView].showNetworkActivityIndicator = YES;
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading."];
    }
    if(alertView.tag == 1)
    {
        if(buttonIndex>0){
            ApiCompleteCallback completeCallback = ^(NSJSONSerialization *responseJSON,NSString * responseNSString){
                [DejalBezelActivityView removeViewAnimated:YES];
                NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                NSString *plistPath = [rootPath stringByAppendingPathComponent:@"refresh_token.plist"];

                NSError *error;
                if(![[NSFileManager defaultManager] removeItemAtPath:plistPath error:&error])
                {
                 //TODO: Handle/Log error
                }
                [unifiGlobalVariable initialValue];
                [self.tabBarController dismissViewControllerAnimated:YES completion:^{
//                  [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"unifiSplashViewController"] animated:NO completion:nil];
                }];



                //             [self.tabBarController.delegate
                //              tabBarController:self.tabBarController
                //              shouldSelectViewController:[self.tabBarController.viewControllers objectAtIndex:0]];  // send didSelectViewController to the tabBarController delegate
            };
            unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:@"https://accounts.google.com/Logout" withCompleteCallback:completeCallback withErrorCallback:nil];
            [object loadGetData];
        }
    }
    else if(alertView.tag == 2){
        if(buttonIndex>0){
            [unifiSystemResource
                 setIosToken:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
                     
                     [self loadSettingInfoWithLoading:NO];
                 }
                 withHandleError:handleError
                 fromTokenId:@"27216b1263b9fa530b2033e6f1c83d3d23e312347ae5d68fef5b630ade49484f" isEnabled:[[[settingsData valueForKey:@"token"] valueForKey:@"enabled"] boolValue] ? @"false":@"true"
            ];
        }
    }
    else if(alertView.tag == 3){
        if(buttonIndex>0){
            [unifiSystemResource
                 setLoadBalancing:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
                      [self loadSettingInfoWithLoading:NO];
                 }
                 withHandleError:handleError
                 withMaxUser:[alertField.text intValue]
                 isEnabled:[[[settingsData valueForKey:@"load_balance"] valueForKey:@"enabled"] boolValue] ? @"true":@"false"
            ];
        }
    }
    else if(alertView.tag == 4){
        if(buttonIndex>0){
            [unifiSystemResource
                setLoadBalancing:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
                      [self loadSettingInfoWithLoading:NO];
                }
                withHandleError:handleError
                withMaxUser:[[[settingsData valueForKey:@"load_balance"] valueForKey:@"max_sta"] intValue]
                isEnabled:[[[settingsData valueForKey:@"load_balance"] valueForKey:@"enabled"] boolValue] ? @"false":@"true"
            ];
        }
    }
    else if(alertView.tag == 5){
        if(buttonIndex>0){
            [unifiSystemResource
                setGroup:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
                     [self loadSettingInfoWithLoading:NO];
                }
                withHandleError:handleError
                fromId:@""
                withName:alertField.text
                andDownload:0
                andUpload:0
             ];
        }
    }
    else if(alertView.tag == 6){
        if(buttonIndex>0){
            [unifiSystemResource
             setGroup:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
                 [self loadSettingInfoWithLoading:NO];
             }
             withHandleError:handleError
             fromId:[[[ settingsData valueForKey:@"usergroup"]objectAtIndex:groupIndex] valueForKey:@"_id"]
             withName:[[[ settingsData valueForKey:@"usergroup"]objectAtIndex:groupIndex] valueForKey:@"name"]
             andDownload:[alertField.text intValue]*8
             andUpload:[[[[ settingsData valueForKey:@"usergroup"]objectAtIndex:groupIndex] valueForKey:@"qos_rate_max_up"] intValue]
             ];
        }
    }
    else if(alertView.tag == 7){
        if(buttonIndex>0){
            [unifiSystemResource
             setGroup:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
                  [self loadSettingInfoWithLoading:NO];
             }
             withHandleError:handleError
             fromId:[[[ settingsData valueForKey:@"usergroup"]objectAtIndex:groupIndex] valueForKey:@"_id"]
             withName:[[[ settingsData valueForKey:@"usergroup"]objectAtIndex:groupIndex] valueForKey:@"name"]
             andDownload:[[[[ settingsData valueForKey:@"usergroup"]objectAtIndex:groupIndex] valueForKey:@"qos_rate_max_down"] intValue]
             andUpload:[alertField.text intValue]*8
             ];
        }
    }
    else if(alertView.tag == 8){
        if(buttonIndex>0){
            [unifiSystemResource
                 deleteGroup:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
                     NSLog(@"%@",responseNSString);
                     [self loadSettingInfoWithLoading:NO];
                 }
                 withHandleError:handleError
                 fromId:[[[ settingsData valueForKey:@"usergroup"]objectAtIndex:groupIndex] valueForKey:@"_id"]
            ];
        }
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleBlackTranslucent;
}
@end
