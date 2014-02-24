//
//  unifiUserViewController2.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 1/17/2557 BE.
//  Copyright (c) 2557 KMUTNB. All rights reserved.
//

#import "unifiDeviceHistoryViewController.h"
#import "unifiDeviceResource.h"
#import "unifiUserProfileViewController.h"
#import "unifiTableViewCell.h"
#import "DejalActivityView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TJSpinner.h"

@interface unifiDeviceHistoryViewController ()

@end

#define LoadLength 15

@implementation unifiDeviceHistoryViewController{
    bool firstLoad;
    unifiApiConnector *searchAPI;
    UITapGestureRecognizer *dismissKeybaordTap;
    NSInteger sessionStart,authStart,sessionLength,authLength;
    ApiErrorCallback handleError;
}

@synthesize deviceMac,session,auth,historySearch,historyTable,filterBtn,filterState,isSearched;

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
    
    
    historyTable.delegate = self;
    historyTable.dataSource = self;
    __weak typeof(self) weakSelf=self;
    
    handleError= ^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:YES];
        unifiFailureViewController *failureController = [[weakSelf storyboard] instantiateViewControllerWithIdentifier:@"unifiFailureViewController"];
        [[weakSelf navigationController] presentViewController:failureController animated:YES completion:nil];
    };
    
    
    [self initialize];
    
}
-(void)initialize{
    
    [filterBtn setSelected:NO];
    filterState=1;
    isSearched=NO;
    session = [[NSMutableArray alloc] init];
    auth = [[NSMutableArray alloc] init];
    [DejalBezelActivityView currentActivityView].showNetworkActivityIndicator = YES;
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading."];

    sessionStart   = 0;
    authStart  = 0;

    sessionLength  = LoadLength;
    authLength = LoadLength;
    
    searchAPI = [[unifiApiConnector alloc] initWithUrl:@""
                                  withCompleteCallback:^(NSJSONSerialization *responseJSON,NSString *reponseString){
                                      for(NSMutableDictionary *json in [responseJSON valueForKey:@"data"]){
                                          if([json valueForKey:@"picture"] == NULL || [json valueForKey:@"picture"] == [NSNull null]){
                                              [json setObject: @"profile.jpg" forKey:@"picture"];
                                          }
                                          [historySearch addObject:json];
                                      }
                                      [historyTable reloadData];
                                  }
                                     withErrorCallback:handleError                 ];
    
    firstLoad=YES;
    [self loadOnlineUserWithLoadmore:NO];
    [self loadOfflineUserWithLoadmore:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backToParent:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)backToHome:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isSearched)return [historySearch count];
    else if(filterState==1)return [session count];
    else return [auth count];
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

    if(filterState==1){
        json = [session objectAtIndex:indexPath.row];
        if ([self.session count] >= sessionLength && indexPath.row == [self.session count] - 2)
            [self loadOnlineUserWithLoadmore:YES];
        NSInteger days = ([[json valueForKey:@"duration"] intValue] / 60 / 60 / 24);
        NSInteger hours = ([[json valueForKey:@"duration"] intValue] / 60 / 60);
        NSInteger minutes = ([[json valueForKey:@"duration"] intValue] / 60);
        NSInteger seconds = ([[json valueForKey:@"duration"] intValue]);
        
        if(days > 0){
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Duration Time : %i d %i h %i m %i s",days,hours%24,minutes%60,seconds%60];
        }
        else if (hours > 0){
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Duration Time : %i h %i m %i s",hours,minutes%60,seconds%60];
        }
        else if (minutes > 0){
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Duration Time : %i m %i s",minutes,seconds%60];
        }
        else if (seconds > 0){
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Duration Time : %i s",seconds];
        }
        cell.secondDetailTextLabel.text = [NSString stringWithFormat:@"Download : %@   ,  Upload : %@",[self getValueWithUnit:[[json valueForKey:@"tx_bytes"] longLongValue ]],[self getValueWithUnit:[[json valueForKey:@"rx_bytes"] longLongValue ]]];
    }
    else{
        json = [auth objectAtIndex:indexPath.row];
        if ([self.auth count] >= authLength && indexPath.row == [self.auth count] - 2)
            [self loadOfflineUserWithLoadmore:YES];
        
        if([json valueForKey:@"fname"] == NULL && [json valueForKey:@"lname"] == NULL)
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Google Name : %@",[json valueForKey:@"email"]];
        else
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Google Name : %@ %@",[json valueForKey:@"fname"],[json valueForKey:@"lname"]];
        cell.secondDetailTextLabel.text = [NSString stringWithFormat:@"Authentication Type : %@",[[json valueForKey:@"auth_type"] boolValue] ? @"No Limited":@"Limited"];
    }
    
    NSDate *today = [NSDate dateWithTimeIntervalSince1970:[[json valueForKey:@"start"] intValue]];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSBuddhistCalendar];
    dateFormat.calendar = calendar;
    [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Date Time : %@",[dateFormat stringFromDate:today]];
    
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    unifiUserProfileViewController * profile = [self.storyboard instantiateViewControllerWithIdentifier:@"unifiUserProfileViewController"];
//    
//    if(isSearched){
//        [profile setGoogleId:[[historySearch objectAtIndex:indexPath.row] valueForKey:@"google_id"]];
//    }
//    else if(filterState==1){
//        [profile setGoogleId:[[session objectAtIndex:indexPath.row] valueForKey:@"google_id"]];
//    }
//    else{
//        [profile setGoogleId:[[auth objectAtIndex:indexPath.row] valueForKey:@"google_id"]];
//    }
//    
//    [[self navigationController] pushViewController:profile animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(IBAction)filter:(id)sender
{
    
    if(filterState==1)
    {
        [sender setSelected:YES];
        filterState=2;
    }
    else {
        [sender setSelected:NO];
        filterState=1;
    }
    
    [self.historyTable reloadData];
}

-(void)loadOnlineUserWithLoadmore:(bool)flag{
    if(flag){
        sessionStart  = sessionLength;
        sessionLength = sessionLength+LoadLength;
    }
    
    [unifiDeviceResource
     getDeviceSessionHistoryList:^(NSJSONSerialization *responseJSON,NSString *reponseString){
         for(NSMutableDictionary *json in [responseJSON valueForKey:@"data"]){
             if([json valueForKey:@"picture"] == NULL || [json valueForKey:@"picture"] == [NSNull null]){
                 [json setObject: @"profile.jpg" forKey:@"picture"];
             }
             [session addObject:json];
         }
         if(!firstLoad){
             [DejalBezelActivityView removeViewAnimated:YES];
             [historyTable reloadData];
         }
         firstLoad=false;
     }
     withHandleError:handleError
     fromStart:sessionStart toLength:sessionLength
     withMac:deviceMac
     ];
    
}

-(void)loadOfflineUserWithLoadmore:(bool)flag{
    if(flag){
        authStart  = authLength;
        authLength = authLength+LoadLength;
    }
    
    [unifiDeviceResource
     getDeviceAuthHistoryList:^(NSJSONSerialization *responseJSON,NSString *reponseString){
         for(NSMutableDictionary *json in [responseJSON valueForKey:@"data"]){
             if([json valueForKey:@"picture"] == NULL || [json valueForKey:@"picture"] == [NSNull null]){
                 [json setObject: @"profile.jpg" forKey:@"picture"];
             }
             [auth addObject:json];
         }
         if(!firstLoad){
             [DejalBezelActivityView removeViewAnimated:YES];
             [historyTable reloadData];
         }
         firstLoad=false;
     }
     withHandleError:handleError
     fromStart:authStart toLength:authLength
     withMac:deviceMac
     ];
}

- (void)failureView:(unifiFailureViewController *)viewController
       retryWithSel:(SEL)selector{
    [self initialize];
    
    
}
-(NSString *)getValueWithUnit:(double)value{
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

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleBlackTranslucent;
}
@end
