//
//  unifiUserViewController2.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 1/17/2557 BE.
//  Copyright (c) 2557 KMUTNB. All rights reserved.
//

#import "unifiNotificationViewController.h"
#import "unifiSystemResource.h"
#import "unifiTableViewCell.h"
#import "DejalActivityView.h"
#import "unifiFailureViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "unifiGlobalVariable.h"
#import "unifiApProfileViewController.h"

@interface unifiNotificationViewController ()

@end

#define LoadLength 15

@implementation unifiNotificationViewController{
    bool firstLoad;
    UITapGestureRecognizer *dismissKeybaordTap;
    NSInteger notificationStart,notificationLength;
    ApiErrorCallback handleError;
    UITextField *alertField;
}
@synthesize notificationList,deviceTable;

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
    
    
    
    deviceTable.delegate = self;
    deviceTable.dataSource = self;
    
    __weak typeof(self) weakSelf=self;
    handleError= ^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:YES];
        unifiFailureViewController *failureController = [[weakSelf storyboard] instantiateViewControllerWithIdentifier:@"unifiFailureViewController"];
        
        [weakSelf presentViewController:failureController animated:YES completion:nil];
    };
    
    [unifiSystemResource setNotification:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
        [[[[self.tabBarController tabBar] items] objectAtIndex:2] setBadgeValue:Nil];
    } withHandleError:handleError withTokenId:[unifiGlobalVariable sharedGlobalData].iosToken];
}
-(void)viewDidAppear:(BOOL)animated{
    [self initialize];
}

- (void)initialize{
    
    notificationList = [[NSMutableArray alloc] init];
    
    [DejalBezelActivityView currentActivityView].showNetworkActivityIndicator = YES;
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading."];
    
    notificationStart   = 0;

    notificationLength  = LoadLength;
    
    firstLoad=YES;
    [self loadNotificationListWithLoadmore:NO];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backToParent:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [notificationList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    unifiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[unifiTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    [cell setCellStyle:TextWithTreeDetailRowStyle];
    
    NSJSONSerialization *json;
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    json = [notificationList objectAtIndex:indexPath.row];
    if ([self.notificationList count] >= notificationLength && indexPath.row == [self.notificationList count] - 2)
        [self loadNotificationListWithLoadmore:YES];
    
    NSDate *today = [NSDate dateWithTimeIntervalSince1970:[[[json valueForKey:@"datetime"] valueForKey:@"sec"] intValue]];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSBuddhistCalendar];
    dateFormat.calendar = calendar;
    [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm:ss"];

    cell.textLabel.text = [NSString stringWithFormat:@"Date Time : %@",[dateFormat stringFromDate:today]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Message : %@ AP was disconnected",[json valueForKey:@"ap_name"]];
    cell.secondDetailTextLabel.text = [NSString stringWithFormat:@"Access Point Mac Address : %@",[json valueForKey:@"ap"]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    unifiApProfileViewController *apProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"unifiApProfileViewController"];
    
    apProfile.mac = [[notificationList objectAtIndex:indexPath.row] valueForKey:@"ap"];
    [self.navigationController pushViewController:apProfile animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(void)loadNotificationListWithLoadmore:(bool)flag{
    if(flag){
        notificationStart  = notificationLength;
        notificationLength = notificationLength+LoadLength;
    }
    
    [unifiSystemResource
        getNotificationList:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
            for(NSMutableDictionary *json in [responseJSON valueForKey:@"data"]){
                [notificationList addObject:json];
            }
            [DejalBezelActivityView removeViewAnimated:YES];
            [deviceTable reloadData];
            NSLog(@"%@",notificationList);
        }
        withHandleError:handleError
        fromStart:notificationStart
        toLength:notificationLength
        withTokenId:[unifiGlobalVariable sharedGlobalData].iosToken
     ];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleBlackTranslucent;
}
@end
