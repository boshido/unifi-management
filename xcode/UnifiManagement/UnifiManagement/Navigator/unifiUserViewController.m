//
//  unifiUserViewController2.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 1/17/2557 BE.
//  Copyright (c) 2557 KMUTNB. All rights reserved.
//

#import "unifiUserViewController.h"
#import "unifiUserResource.h"
#import "unifiUserProfileViewController.h"
#import "unifiTableViewCell.h"
#import "DejalActivityView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TJSpinner.h"

@interface unifiUserViewController ()

@end

#define LoadLength 15

@implementation unifiUserViewController{
    bool firstLoad;
    unifiApiConnector *searchAPI;
    UITapGestureRecognizer *dismissKeybaordTap;
    NSInteger onlineStart,offlineStart,onlineLength,offlineLength,searchStart,searchLength;
    ApiErrorCallback handleError;
}
@synthesize userOnline,userOffline,userSearch,userTable,searchBar,filterBtn,filterState,isSearched;

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
    
    userTable.delegate = self;
    userTable.dataSource = self;
    searchBar.delegate = self;
    __weak typeof(self) weakSelf=self;
    
    handleError= ^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:YES];
        unifiFailureViewController *failureController = [[weakSelf storyboard] instantiateViewControllerWithIdentifier:@"unifiFailureViewController"];
        failureController.delegate = weakSelf;
        [[weakSelf navigationController] presentViewController:failureController animated:YES completion:nil];
    };

    
    [self initialize];
    
}
-(void)initialize{
    
    [filterBtn setSelected:NO];
    filterState=1;
    isSearched=NO;
    userOnline = [[NSMutableArray alloc] init];
    userOffline = [[NSMutableArray alloc] init];
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
                                          if([json valueForKey:@"picture"] == NULL || [json valueForKey:@"picture"] == [NSNull null]){
                                              [json setObject: @"profile.jpg" forKey:@"picture"];
                                          }
                                          [userSearch addObject:json];
                                      }
                                      [userTable reloadData];
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
        userSearch      = [[NSMutableArray alloc] init];
        [self loadSearchUserWithLoadmore:NO];
    }
    
    [self.userTable reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isSearched)return [userSearch count];
    else if(filterState==1)return [userOnline count];
    else return [userOffline count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    unifiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[unifiTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    [cell setCellStyle:ImageWithTextStyle];
    
    NSJSONSerialization *json;
    if(isSearched){
        json = [userSearch objectAtIndex:indexPath.row];
        if ([self.userSearch count] >= searchLength && indexPath.row == [self.userSearch count] - 2)
            [self loadSearchUserWithLoadmore:YES];

    }
    else if(filterState==1){
        json = [userOnline objectAtIndex:indexPath.row];
        if ([self.userOnline count] >= onlineLength && indexPath.row == [self.userOnline count] - 2)
            [self loadOnlineUserWithLoadmore:YES];
    }
    else{
        json = [userOffline objectAtIndex:indexPath.row];
        if ([self.userOffline count] >= offlineLength && indexPath.row == [self.userOffline count] - 2)
            [self loadOfflineUserWithLoadmore:YES];
    }
    
    if([json valueForKey:@"name"] == NULL || [json valueForKey:@"name"] == [NSNull null])
        cell.textLabel.text = [json valueForKey:@"email"];
    else
        cell.textLabel.text = [json valueForKey:@"name"];
    
    [cell.imageView setImageWithURL:[NSURL URLWithString:[json valueForKey:@"picture"]]
                   placeholderImage:[UIImage imageNamed:@"profile.jpg"] options:SDWebImageRefreshCached];

    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    unifiUserProfileViewController * profile = [self.storyboard instantiateViewControllerWithIdentifier:@"unifiUserProfileViewController"];
    
    if(isSearched){
        [profile setUserData:[userSearch objectAtIndex:indexPath.row]];
    }
    else if(filterState==1){
        [profile setUserData:[userOnline objectAtIndex:indexPath.row]];
    }
    else{
        [profile setUserData:[userOffline objectAtIndex:indexPath.row]];
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
        userSearch      = [[NSMutableArray alloc] init];
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
        userSearch      = [[NSMutableArray alloc] init];
        [self loadSearchUserWithLoadmore:NO];
    }
    
    [self.userTable reloadData];
}

-(void)loadOnlineUserWithLoadmore:(bool)flag{
    if(flag){
        onlineStart  = onlineLength;
        onlineLength = onlineLength+LoadLength;
    }
    
    [unifiUserResource
     getOnlineUserList:^(NSJSONSerialization *responseJSON,NSString *reponseString){
         for(NSMutableDictionary *json in [responseJSON valueForKey:@"data"]){
             if([json valueForKey:@"picture"] == NULL || [json valueForKey:@"picture"] == [NSNull null]){
                 [json setObject: @"profile.jpg" forKey:@"picture"];
             }
            [userOnline addObject:json];
         }
         if(!firstLoad){
             [DejalBezelActivityView removeViewAnimated:YES];
             [userTable reloadData];
         }
         firstLoad=false;
     }
     withHandleError:handleError
     fromStart:onlineStart toLength:onlineLength 
     ];
    
}

-(void)loadOfflineUserWithLoadmore:(bool)flag{
    if(flag){
        offlineStart  = offlineLength;
        offlineLength = offlineLength+LoadLength;
    }
        
    [unifiUserResource
     getOfflineUserList:^(NSJSONSerialization *responseJSON,NSString *reponseString){
         for(NSMutableDictionary *json in [responseJSON valueForKey:@"data"]){
             if([json valueForKey:@"picture"] == NULL || [json valueForKey:@"picture"] == [NSNull null]){
                [json setObject: @"profile.jpg" forKey:@"picture"];
             }
             [userOffline addObject:json];
         }
         if(!firstLoad){
             [DejalBezelActivityView removeViewAnimated:YES];
             [userTable reloadData];
         }
         firstLoad=false;
     }
     withHandleError:handleError
     fromStart:offlineStart toLength:offlineLength
     ];
}

-(void)loadSearchUserWithLoadmore:(bool)flag{
    if(flag){
        searchStart  = searchLength;
        searchLength = searchLength+LoadLength;
    }
    if(filterState==1)
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

- (void)failureView:(unifiFailureViewController *)viewController
       retryWithSel:(SEL)selector{
    [self initialize];

}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleBlackTranslucent;
}
@end
