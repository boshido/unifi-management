//
//  unifiUserViewController2.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 1/17/2557 BE.
//  Copyright (c) 2557 KMUTNB. All rights reserved.
//

#import "unifiSelectDeviceViewController.h"
#import "unifiUserResource.h"
#import "unifiDeviceResource.h"
#import "unifiProfileViewController.h"
#import "unifiTableViewCell.h"
#import "DejalActivityView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "unifiSwitch.h"

@interface unifiSelectDeviceViewController ()

@end

#define LoadLength 15

@implementation unifiSelectDeviceViewController{
    bool firstLoad;
    unifiApiConnector *searchAPI;
    UITapGestureRecognizer *dismissKeybaordTap;
    NSInteger onlineStart,offlineStart,onlineLength,offlineLength,searchStart,searchLength;
}
@synthesize deviceOnline,deviceOffline,deviceSearch,deviceTable,searchBar,filterState,isSearched,userData,delegate;

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
    filterState=1;
    isSearched=NO;
    deviceOnline = [[NSMutableArray alloc] init];
    deviceOffline = [[NSMutableArray alloc] init];
    [DejalBezelActivityView currentActivityView].showNetworkActivityIndicator = YES;
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading."];
    
    searchStart    = 0;
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
                                     withErrorCallback:nil
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

-(IBAction)backToParent:(id)sender{
    if ([self.delegate respondsToSelector:@selector(unifiSelectDeviceView:finishAddDevice:)]) {
        [self.delegate unifiSelectDeviceView:self finishAddDevice:true];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    NSJSONSerialization *json;
    unifiSwitch *switchView = [[unifiSwitch alloc] initWithFrame:CGRectZero];
    if(isSearched){
        json = [deviceSearch objectAtIndex:indexPath.row];
        if ([self.deviceSearch count] >= searchLength && indexPath.row == [self.deviceSearch count] - 2)
            [self loadSearchDeviceWithLoadmore:YES];
        [switchView setOn:[[[deviceSearch objectAtIndex:indexPath.row] valueForKey:@"switch"] boolValue] animated:NO];
    }
    else if(filterState==1){
        json = [deviceOnline objectAtIndex:indexPath.row];
        if ([self.deviceOnline count] >= onlineLength && indexPath.row == [self.deviceOnline count] - 2)
            [self loadOnlineDeviceWithLoadmore:YES];
         cell.detailTextLabel.text = [json valueForKey:@"ip"];
        [switchView setOn:[[[deviceOnline objectAtIndex:indexPath.row] valueForKey:@"switch"] boolValue] animated:NO];
    }
    else{
        json = [deviceOffline objectAtIndex:indexPath.row];
        if ([self.deviceOffline count] >= offlineLength && indexPath.row == [self.deviceOffline count] - 2)
            [self loadOfflineDeviceWithLoadmore:YES];
         cell.detailTextLabel.text = [json valueForKey:@"mac"];
        [switchView setOn:[[[deviceOffline objectAtIndex:indexPath.row] valueForKey:@"switch"] boolValue] animated:NO];
       // NSLog(@"%@",[[[deviceOffline objectAtIndex:indexPath.row] valueForKey:@"switch"] boolValue] ? @"true" : @"false");
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [switchView initParameter];
    [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [switchView setParameter:[json valueForKey:@"hostname"] withKey:@"hostname"];
    [switchView setParameter:[json valueForKey:@"mac"] withKey:@"mac"];
    [switchView setParameter:[NSNumber numberWithInteger: indexPath.row] withKey:@"index"];
    cell.accessoryView = switchView;
    
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
    unifiProfileViewController * profile = [self.storyboard instantiateViewControllerWithIdentifier:@"unifiProfileViewController"];
    
    if(isSearched){
        [profile setUserData:[deviceSearch objectAtIndex:indexPath.row]];
    }
    else if(filterState==1){
        [profile setUserData:[deviceOnline objectAtIndex:indexPath.row]];
    }
    else{
        [profile setUserData:[deviceOffline objectAtIndex:indexPath.row]];
    }
    
    [[self navigationController] pushViewController:profile animated:YES];
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

-(void)switchChanged:(id)sender{
    unifiSwitch *switchView = (unifiSwitch*)sender;
    [DejalBezelActivityView currentActivityView].showNetworkActivityIndicator = YES;
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading."];

    if([switchView isOn]){
        [unifiDeviceResource
            authorizeDevice:^(NSJSONSerialization *responseJSON,NSString *reponseString){
                if(isSearched){
                    [[deviceSearch objectAtIndex:[[switchView getParameterByKey:@"index"] intValue]] setValue:[NSNumber numberWithInteger: 1] forKey:@"switch"];
                }
                else if(filterState==1)
                {
                    [[deviceOnline objectAtIndex:[[switchView getParameterByKey:@"index"] intValue]] setValue:[NSNumber numberWithInteger: 1] forKey:@"switch"];
                }
                else {
                    [[deviceOffline objectAtIndex:[[switchView getParameterByKey:@"index"] intValue]] setValue:[NSNumber numberWithInteger: 1] forKey:@"switch"];
                }

                [DejalBezelActivityView removeViewAnimated:YES];
            }
            withHandleError:^(NSError *error) {
                [switchView setOn:NO animated:YES];
//                [DejalBezelActivityView removeViewAnimated:YES];
            }
            fromGoogleId:[userData valueForKey:@"google_id"]
            andHostname:[switchView getParameterByKey:@"hostname"]
            andMac:[switchView getParameterByKey:@"mac"]
            andFirstName:[userData valueForKey:@"fname"]
            andLastName:[userData valueForKey:@"lname"]
            andEmail:[userData valueForKey:@"email"]
         ];
    }
    else{
        [unifiDeviceResource
            unAuthorizeDevice:^(NSJSONSerialization *responseJSON,NSString *reponseString){
                if(isSearched){
                    [[deviceSearch objectAtIndex:[[switchView getParameterByKey:@"index"] intValue]] setValue:[NSNumber numberWithInteger: 0] forKey:@"switch"];
                }
                else if(filterState==1)
                {
                    [[deviceOnline objectAtIndex:[[switchView getParameterByKey:@"index"] intValue]] setValue:[NSNumber numberWithInteger: 0] forKey:@"switch"];
                }
                else {
                    [[deviceOffline objectAtIndex:[[switchView getParameterByKey:@"index"] intValue]] setValue:[NSNumber numberWithInteger: 0] forKey:@"switch"];
                }
                [DejalBezelActivityView removeViewAnimated:YES];
            }
            withHandleError:^(NSError *error) {
                [switchView setOn:YES animated:YES];
//                 [DejalBezelActivityView removeViewAnimated:YES];
            }
            fromMac:[switchView getParameterByKey:@"mac"]
        ];
    }
}

-(void)loadOnlineDeviceWithLoadmore:(bool)flag{
    if(flag){
        onlineStart  = onlineLength;
        onlineLength = onlineLength+LoadLength;
    }
    
    [unifiDeviceResource
     getPendingDeviceList:^(NSJSONSerialization *responseJSON,NSString *reponseString){
         for(NSMutableDictionary *json in [responseJSON valueForKey:@"data"]){
             [json setValue:[NSNumber numberWithInteger: 0] forKey:@"switch"];
             [deviceOnline addObject:json];
         }
         if(!firstLoad){
             [DejalBezelActivityView removeViewAnimated:YES];
             [deviceTable reloadData];
         }
         firstLoad=false;
     }
     withHandleError:^(NSError *error) {
         [DejalBezelActivityView removeViewAnimated:YES];
     }
     fromStart:onlineStart toLength:onlineLength
     ];
}

-(void)loadOfflineDeviceWithLoadmore:(bool)flag{
    if(flag){
        offlineStart  = offlineLength;
        offlineLength = offlineLength+LoadLength;
    }
    
    [unifiDeviceResource
     getUnAuthorizedDeviceList:^(NSJSONSerialization *responseJSON,NSString *reponseString){
         for(NSMutableDictionary *json in [responseJSON valueForKey:@"data"]){
             [json setValue:[NSNumber numberWithInteger: 0] forKey:@"switch"];
             [deviceOffline addObject:json];
         }
         if(!firstLoad){
             [DejalBezelActivityView removeViewAnimated:YES];
             [deviceTable reloadData];
         }
         firstLoad=false;
     }
     withHandleError:^(NSError *error) {
         [DejalBezelActivityView removeViewAnimated:YES];
     }
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
        [searchAPI setUrl:[NSString stringWithFormat:@"http://%@/unifi/pending-device-list?start=%i&length=%i&search=%@",ApiServerAddress,searchStart,searchLength,[searchBar text]]];
        [searchAPI loadGetData];
    }
    else{
        [searchAPI cancel];
        [searchAPI setUrl:[NSString stringWithFormat:@"http://%@/unifi/unauthorized-device-list?start=%i&length=%i&search=%@",ApiServerAddress,searchStart,searchLength,[searchBar text]]];
        [searchAPI loadGetData];
    }
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleBlackTranslucent;
}
@end
