//
//  unifiUserViewController2.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 1/17/2557 BE.
//  Copyright (c) 2557 KMUTNB. All rights reserved.
//

#import "unifiBlockedListViewController.h"
#import "unifiUserResource.h"
#import "unifiDeviceResource.h"
#import "unifiUserProfileViewController.h"
#import "unifiTableViewCell.h"
#import "DejalActivityView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "unifiSwitch.h"


@interface unifiBlockedListViewController ()

@end

#define LoadLength 15

@implementation unifiBlockedListViewController{
    unifiApiConnector *searchAPI;
    UITapGestureRecognizer *dismissKeybaordTap;
    NSInteger blockedStart,blockedLength,searchStart,searchLength;
    ApiErrorCallback handleError;
    UITextField *alertField;
}
@synthesize header,blockedList,blockedSearch,deviceTable,searchBar,isSearched;

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
        failureController.delegate = weakSelf;
        [weakSelf presentViewController:failureController animated:YES completion:nil];
    };
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [self initialize];
}

- (void)initialize{
    
    isSearched=NO;
    blockedList = [[NSMutableArray alloc] init];
    [DejalBezelActivityView currentActivityView].showNetworkActivityIndicator = YES;
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading."];
    
    searchStart    = 0;
    blockedStart   = 0;
    
    searchLength  = LoadLength;
    blockedLength  = LoadLength;
    
    searchAPI = [[unifiApiConnector alloc] initWithUrl:@""
                                  withCompleteCallback:^(NSJSONSerialization *responseJSON,NSString *responseNSString){
                                      NSLog(@"%@",responseNSString);
                                      for(NSMutableDictionary *json in [responseJSON valueForKey:@"data"]){
                                            [json setValue:[NSNumber numberWithInteger: 1] forKey:@"switch"];
                                          [blockedSearch addObject:json];
                                      }
                                      [DejalBezelActivityView removeViewAnimated:YES];
                                      [deviceTable reloadData];
                                  }
                                     withErrorCallback:handleError
                 ];
    [self loadBlockedDeviceWithLoadmore:NO];
    
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
        blockedSearch      = [[NSMutableArray alloc] init];
        [self loadSearchDeviceWithLoadmore:NO];
    }
    
    [self.deviceTable reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isSearched)return [blockedSearch count];
    else return [blockedList count];
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
        json = [blockedSearch objectAtIndex:indexPath.row];
        if ([self.blockedSearch count] >= searchLength && indexPath.row == [self.blockedSearch count] - 2)
            [self loadSearchDeviceWithLoadmore:YES];
    }
    else {
        json = [blockedList objectAtIndex:indexPath.row];
        if ([self.blockedList count] >= blockedLength && indexPath.row == [self.blockedList count] - 2)
            [self loadBlockedDeviceWithLoadmore:YES];
        
    }
    [switchView setOn:[[[blockedList objectAtIndex:indexPath.row] valueForKey:@"switch"] boolValue] animated:NO];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [switchView initParameter];
    [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
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
    //    unifiUserProfileViewController * profile = [self.storyboard instantiateViewControllerWithIdentifier:@"unifiUserProfileViewController"];
    //
    //    if(isSearched){
    //        [profile setUserData:[blockedSearch objectAtIndex:indexPath.row]];
    //    }
    //    else if(filterState==1){
    //        [profile setUserData:[blockedList objectAtIndex:indexPath.row]];
    //    }
    //    else{
    //        [profile setUserData:[deviceAdd objectAtIndex:indexPath.row]];
    //    }
    //
    //    [[self navigationController] pushViewController:profile animated:YES];
}

- (void) dismissKeyboard
{
    [self.view removeGestureRecognizer:dismissKeybaordTap];
    // add self
    [self.searchBar resignFirstResponder];
}

-(void)switchChanged:(id)sender{
    
    unifiSwitch *switchView = (unifiSwitch*)sender;
    [DejalBezelActivityView currentActivityView].showNetworkActivityIndicator = YES;
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading."];
    
    if([switchView isOn]){
        [unifiDeviceResource
         blockDevice:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
             if(isSearched){
                 [[blockedSearch objectAtIndex:[[switchView getParameterByKey:@"index"] intValue]] setValue:[NSNumber numberWithInteger: 1] forKey:@"switch"];
             }
             else
             {
                 [[blockedList objectAtIndex:[[switchView getParameterByKey:@"index"] intValue]] setValue:[NSNumber numberWithInteger: 1] forKey:@"switch"];
             }
             
             [DejalBezelActivityView removeViewAnimated:YES];
         }
         withHandleError:handleError
         fromMac:[switchView getParameterByKey:@"mac"]
         ];
    }
    else{
        [unifiDeviceResource
         unBlockDevice:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
             if(isSearched){
                 [[blockedSearch objectAtIndex:[[switchView getParameterByKey:@"index"] intValue]] setValue:[NSNumber numberWithInteger: 0] forKey:@"switch"];
             }
             else
             {
                 [[blockedList objectAtIndex:[[switchView getParameterByKey:@"index"] intValue]] setValue:[NSNumber numberWithInteger: 0] forKey:@"switch"];
             }
             [DejalBezelActivityView removeViewAnimated:YES];
         }
         withHandleError:handleError
         fromMac:[switchView getParameterByKey:@"mac"]
         ];
        
        
    }
}

-(void)loadBlockedDeviceWithLoadmore:(bool)flag{
    if(flag){
        blockedStart  = blockedLength;
        blockedLength = blockedLength+LoadLength;
    }
    
    [unifiDeviceResource
     getBlockedDeviceList:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
         for(NSMutableDictionary *json in [responseJSON valueForKey:@"data"]){
             [json setValue:[NSNumber numberWithInteger: 1] forKey:@"switch"];
             [blockedList addObject:json];
         }
         [DejalBezelActivityView removeViewAnimated:YES];
         [deviceTable reloadData];
     }
     withHandleError:handleError
     fromStart:blockedStart
     toLength:blockedLength
     ];
}

-(void)loadSearchDeviceWithLoadmore:(bool)flag{
    if(flag){
        searchStart  = searchLength;
        searchLength = searchLength+LoadLength;
    }
   
    [searchAPI cancel];
    [searchAPI setUrl:[NSString stringWithFormat:@"http://%@/unifi/blocked-device-list?start=%i&length=%i&search=%@",ApiServerAddress,searchStart,searchLength,[searchBar text]]];
    [searchAPI loadGetData];

}

- (void)failureView:(unifiFailureViewController *)viewController
       retryWithSel:(SEL)selector{
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleBlackTranslucent;
}
@end
