//
//  unifiUserViewController2.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 1/17/2557 BE.
//  Copyright (c) 2557 KMUTNB. All rights reserved.
//

#import "unifiDeviceViewController.h"
#import "unifiUserResource.h"
#import "unifiDeviceResource.h"
#import "unifiDeviceProfileViewController.h"
#import "unifiTableViewCell.h"
#import "DejalActivityView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "unifiSwitch.h"
#import "unifiFailureViewController.h"
#import "unifiBlockedListViewController.h"


@interface unifiDeviceViewController ()

@end

#define LoadLength 15

@implementation unifiDeviceViewController{
    bool firstLoad;
    unifiApiConnector *searchAPI;
    UITapGestureRecognizer *dismissKeybaordTap;
    NSInteger onlineStart,offlineStart,onlineLength,offlineLength,searchStart,searchLength;
    ApiErrorCallback handleError;
}
@synthesize deviceOnline,deviceOffline,deviceSearch,deviceTable,searchBar,filterBtn,filterState,isSearched,userData;

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
    bottomBorder.frame = CGRectMake(0.0f, searchBar.frame.size.height, searchBar.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:0.867 green:0.867 blue:0.867 alpha:1.0].CGColor;
    [searchBar.layer addSublayer:bottomBorder ];
    
    [searchBar setBackgroundImage:[UIImage imageNamed:@"BlackBG2.png"]];
    [searchBar setTranslucent:YES];
    
    deviceTable.delegate = self;
    deviceTable.dataSource = self;
    searchBar.delegate = self;
    __weak typeof(self) weakSelf=self;
    
    handleError= ^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:YES];
        unifiFailureViewController *failureController = [[weakSelf storyboard] instantiateViewControllerWithIdentifier:@"unifiFailureViewController"];
        [weakSelf presentViewController:failureController animated:YES completion:nil];
    };
    [self initialize];
    
}
-(void)viewDidAppear:(BOOL)animated{
}

- (void)initialize{
    
    [filterBtn setSelected:NO];
    filterState=1;
    isSearched=NO;
    deviceOnline = [[NSMutableArray alloc] init];
    deviceOffline = [[NSMutableArray alloc] init];
    [DejalBezelActivityView currentActivityView].showNetworkActivityIndicator = YES;
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading."];
    
    searchStart   = 0;
    onlineStart   = 0;
    offlineStart  = 0;
    
    searchLength  = LoadLength;
    onlineLength  = LoadLength;
    offlineLength = LoadLength;
    
    searchAPI = [[unifiApiConnector alloc] initWithUrl:@""
                                  withCompleteCallback:^(NSJSONSerialization *responseJSON,NSString *reponseString){
                                      for(NSMutableDictionary *json in [responseJSON valueForKey:@"data"]){
                                          [json setValue:[NSNumber numberWithInteger: 0] forKey:@"switch"];
                                          [deviceSearch addObject:json];
                                      }
                                      [DejalBezelActivityView removeViewAnimated:YES];
                                      [deviceTable reloadData];
                                  }
                                     withErrorCallback:handleError
                 ];
    
    firstLoad=YES;
    [self loadOnlineDeviceWithLoadmore:NO];
    [self loadOfflineDeviceWithLoadmore:NO];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)showBlockedDevice:(id)sender{
    unifiBlockedListViewController *blocked = [self.storyboard instantiateViewControllerWithIdentifier:@"unifiBlockedListViewController"];
    [self.navigationController pushViewController:blocked animated:YES];
}
-(IBAction)backToParent:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)backToHome:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)bar {
    dismissKeybaordTap = [[UITapGestureRecognizer alloc]
                          initWithTarget:self
                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:dismissKeybaordTap];
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    
    if(text.length == 0)
    {
        isSearched = NO;
    }
    else
    {
        isSearched      = YES;
        searchStart     = 0;
        searchLength    = LoadLength;
        deviceSearch      = [[NSMutableArray alloc] init];
        [self loadSearchDeviceWithLoadmore:NO];
    }
    
    [self.deviceTable reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isSearched)return [deviceSearch count];
    else if(filterState==1)return [deviceOnline count];
    else return [deviceOffline count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    unifiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[unifiTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    
    [cell setCellStyle:TextWithDetailStyle];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    NSJSONSerialization *json;
    if(isSearched){
        json = [deviceSearch objectAtIndex:indexPath.row];
        if ([self.deviceSearch count] >= searchLength && indexPath.row == [self.deviceSearch count] - 2)
            [self loadSearchDeviceWithLoadmore:YES];
    }
    else if(filterState==1){
        json = [deviceOnline objectAtIndex:indexPath.row];
        if ([self.deviceOnline count] >= onlineLength && indexPath.row == [self.deviceOnline count] - 2)
            [self loadOnlineDeviceWithLoadmore:YES];
        cell.detailTextLabel.text = [json valueForKey:@"ip"];
    }
    else{
        json = [deviceOffline objectAtIndex:indexPath.row];
        if ([self.deviceOffline count] >= offlineLength && indexPath.row == [self.deviceOffline count] - 2)
            [self loadOfflineDeviceWithLoadmore:YES];
        cell.detailTextLabel.text = [json valueForKey:@"mac"];
        // NSLog(@"%@",[[[deviceOffline objectAtIndex:indexPath.row] valueForKey:@"switch"] boolValue] ? @"true" : @"false");
    }
    
    if([json valueForKey:@"hostname"] == NULL || [json valueForKey:@"hostname"] == [NSNull null]){
        cell.textLabel.text = @"No Hostname";
        [cell.imageView setImage:[UIImage imageNamed:@"Unknow.png"]];
    }
    else{
        
        cell.textLabel.text = [json valueForKey:@"hostname"];
        NSRange search = [[json valueForKey:@"hostname"] rangeOfString:@"iphone" options:NSCaseInsensitiveSearch];
        if(search.location != NSNotFound)
            [cell.imageView setImage:[UIImage imageNamed:@"Apple.png"]];
        else{
            search = [[json valueForKey:@"hostname"] rangeOfString:@"ipad" options:NSCaseInsensitiveSearch];
            if(search.location != NSNotFound)
                [cell.imageView setImage:[UIImage imageNamed:@"Apple.png"]];
            else{
                search = [[json valueForKey:@"hostname"]  rangeOfString:@"android" options:NSCaseInsensitiveSearch];
                if(search.location != NSNotFound)
                    [cell.imageView setImage:[UIImage imageNamed:@"Android.png"]];
                else{
                    search = [[json valueForKey:@"hostname"]  rangeOfString:@"windows" options:NSCaseInsensitiveSearch];
                    if(search.location != NSNotFound)
                        [cell.imageView setImage:[UIImage imageNamed:@"Windows.png"]];
                    else
                        [cell.imageView setImage:[UIImage imageNamed:@"PC.png"]];
                }
            }
        }
    }
    
    
    
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    unifiDeviceProfileViewController *deviceProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"unifiDeviceProfileViewController"];
   
    if(isSearched){
        deviceProfile.deviceMac = [[deviceSearch objectAtIndex:indexPath.row] valueForKey:@"mac"];
    }
    else if(filterState==1){
        deviceProfile.deviceMac = [[deviceOnline objectAtIndex:indexPath.row] valueForKey:@"mac"];
    }
    else{
        deviceProfile.deviceMac = [[deviceOffline objectAtIndex:indexPath.row] valueForKey:@"mac"];
    }
    
     [self.navigationController pushViewController:deviceProfile animated:YES];
}

- (void) dismissKeyboard
{
    [self.view removeGestureRecognizer:dismissKeybaordTap];
    // add self
    [self.searchBar resignFirstResponder];
}

-(IBAction)filter:(id)sender
{
    
    if(isSearched){
        searchStart     = 0;
        searchLength    = LoadLength;
        deviceSearch      = [[NSMutableArray alloc] init];
        if(filterState !=1 )
        {
            [searchAPI cancel];
            [searchAPI setUrl:[NSString stringWithFormat:@"http://%@/unifi/online-user-list?start=%i&length=%i&search=%@",ApiServerAddress,searchStart,searchLength,[searchBar text]]];
            [searchAPI loadGetData];
        }
        else{
            [searchAPI cancel];
            [searchAPI setUrl:[NSString stringWithFormat:@"http://%@/unifi/offline-user-list?start=%i&length=%i&search=%@",ApiServerAddress,searchStart,searchLength,[searchBar text]]];
            [searchAPI loadGetData];
        }
    }
    if(filterState==1)
    {
        [sender setSelected:YES];
        filterState=2;
    }
    else {
        [sender setSelected:NO];
        filterState=1;
    }
    
    if(isSearched){
        searchStart     = 0;
        searchLength    = LoadLength;
        deviceSearch      = [[NSMutableArray alloc] init];
        [self loadSearchDeviceWithLoadmore:NO];
    }
    
    [self.deviceTable reloadData];
}

-(void)loadOnlineDeviceWithLoadmore:(bool)flag{
    if(flag){
        onlineStart  = onlineLength;
        onlineLength = onlineLength+LoadLength;
    }
    
    [unifiDeviceResource
      getOnlineDeviceList:^(NSJSONSerialization *responseJSON,NSString *reponseString){
          
          NSLog(@"%@",responseJSON);
         for(NSMutableDictionary *json in [responseJSON valueForKey:@"data"]){
             [deviceOnline addObject:json];
         }
         if(!firstLoad){
             [DejalBezelActivityView removeViewAnimated:YES];
             [deviceTable reloadData];
         }
         firstLoad=false;
     }
     withHandleError:handleError
     fromStart:onlineStart toLength:onlineLength
     ];
}

-(void)loadOfflineDeviceWithLoadmore:(bool)flag{
    if(flag){
        offlineStart  = offlineLength;
        offlineLength = offlineLength+LoadLength;
    }
    
    [unifiDeviceResource
     getOfflineDeviceList:^(NSJSONSerialization *responseJSON,NSString *reponseString){
         for(NSMutableDictionary *json in [responseJSON valueForKey:@"data"]){
             [deviceOffline addObject:json];
         }
         if(!firstLoad){
             [DejalBezelActivityView removeViewAnimated:YES];
             [deviceTable reloadData];
         }
         firstLoad=false;
     }
     withHandleError:handleError
     fromStart:offlineStart toLength:offlineLength
     ];
}

-(void)loadSearchDeviceWithLoadmore:(bool)flag{
    if(flag){
        searchStart  = searchLength;
        searchLength = searchLength+LoadLength;
    }
    if(filterState==1)
    {
        [searchAPI cancel];
        [searchAPI setUrl:[NSString stringWithFormat:@"http://%@/unifi/online-device-list?start=%i&length=%i&search=%@",ApiServerAddress,searchStart,searchLength,[searchBar text]]];
        [searchAPI loadGetData];
    }
    else{
        [searchAPI cancel];
        [searchAPI setUrl:[NSString stringWithFormat:@"http://%@/unifi/offline-device-list?start=%i&length=%i&search=%@",ApiServerAddress,searchStart,searchLength,[searchBar text]]];
        [searchAPI loadGetData];
    }
}

- (void)failureView:(unifiFailureViewController *)viewController
       retryWithSel:(SEL)selector{
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleBlackTranslucent;
}
@end
