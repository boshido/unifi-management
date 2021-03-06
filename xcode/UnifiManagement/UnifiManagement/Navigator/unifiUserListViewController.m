//
//  unifiUserViewController2.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 1/17/2557 BE.
//  Copyright (c) 2557 KMUTNB. All rights reserved.
//

#import "unifiUserListViewController.h"
#import "unifiUserResource.h"
#import "unifiDeviceResource.h"
#import "unifiUserProfileViewController.h"
#import "unifiTableViewCell.h"
#import "DejalActivityView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TJSpinner.h"

@interface unifiUserListViewController ()

@end

#define LoadLength 15

@implementation unifiUserListViewController{
    bool firstLoad;
    unifiApiConnector *searchAPI;
    UITapGestureRecognizer *dismissKeybaordTap;
    NSInteger userStart,userLength,searchStart,searchLength;
    ApiErrorCallback handleError;
}
@synthesize userList,userSearch,userTable,searchBar,isSearched,deviceHostname,deviceMac;

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
        [[weakSelf navigationController] presentViewController:failureController animated:YES completion:nil];
    };
    
    
    [self initialize];
    
}
-(void)initialize{

    isSearched=NO;
    userList = [[NSMutableArray alloc] init];
    
    [DejalBezelActivityView currentActivityView].showNetworkActivityIndicator = YES;
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading."];
    
    searchStart    = 0;
    userStart   = 0;
    
    searchLength  = LoadLength;
    userLength  = LoadLength;
    
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
    
    [self loadUserWithLoadmore:NO];
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
    else return [userList count];
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
    else{
        json = [userList objectAtIndex:indexPath.row];
        if ([self.userList count] >= userLength && indexPath.row == [self.userList count] - 2)
            [self loadUserWithLoadmore:YES];
    }
    
    if([json valueForKey:@"name"] == NULL || [json valueForKey:@"name"] == [NSNull null])
        cell.textLabel.text = [json valueForKey:@"email"];
    else
        cell.textLabel.text = [json valueForKey:@"name"];
    
    if([json valueForKey:@"picture"] != nil)
        [cell.imageView setImageWithURL:[NSURL URLWithString:[json valueForKey:@"picture"]]
                       placeholderImage:[UIImage imageNamed:@"profile.jpg"] options:SDWebImageRefreshCached];
    else
        cell.imageView.image = [UIImage imageNamed:@"profile.jpg"];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    NSJSONSerialization *json;
    if(isSearched){
        json = [userSearch objectAtIndex:indexPath.row];
    }
    else{
        json = [userList objectAtIndex:indexPath.row];
    }
   
    [unifiDeviceResource
     authorizeDevice:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
         [self.navigationController popViewControllerAnimated:YES];
     }
     withHandleError:handleError
     fromGoogleId:[json valueForKey:@"google_id"]
     andHostname:deviceHostname
     andMac:deviceMac
     andFirstName:[json valueForKey:@"fname"]
     andLastName:[json valueForKey:@"lname"]
     andEmail:[json valueForKey:@"email"]
     ];
}

- (void) dismissKeyboard
{
    [self.view removeGestureRecognizer:dismissKeybaordTap];
    // add self
    [self.searchBar resignFirstResponder];
}

-(void)loadUserWithLoadmore:(bool)flag{
    if(flag){
        userStart  = userLength;
        userLength = userLength+LoadLength;
    }
    
    [unifiUserResource
     getUserList:^(NSJSONSerialization *responseJSON,NSString *reponseString){
         for(NSMutableDictionary *json in [responseJSON valueForKey:@"data"]){
             if([json valueForKey:@"picture"] == NULL || [json valueForKey:@"picture"] == [NSNull null]){
                 [json setObject: @"profile.jpg" forKey:@"picture"];
             }
             [userList addObject:json];
         }

        [DejalBezelActivityView removeViewAnimated:YES];
        [userTable reloadData];
     }
     withHandleError:handleError
     fromStart:userStart toLength:userLength
     ];
    
}

-(void)loadSearchUserWithLoadmore:(bool)flag{
    if(flag){
        searchStart  = searchLength;
        searchLength = searchLength+LoadLength;
    }
    
    [searchAPI cancel];
    [searchAPI setUrl:[NSString stringWithFormat:@"http://%@/unifi/user-list?start=%i&length=%i&search=%@",ApiServerAddress,searchStart,searchLength,[searchBar text]]];
    [searchAPI loadGetData];
  
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleBlackTranslucent;
}
@end
