//
//  unifiUserViewController2.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 1/17/2557 BE.
//  Copyright (c) 2557 KMUTNB. All rights reserved.
//

#import "unifiAddBandwidthViewController.h"
#import "unifiUserResource.h"
#import "unifiSystemResource.h"
#import "unifiUserProfileViewController.h"
#import "unifiTableViewCell.h"
#import "DejalActivityView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "unifiSwitch.h"


@interface unifiAddBandwidthViewController ()

@end

#define LoadLength 15

@implementation unifiAddBandwidthViewController{
    bool firstLoad;
    unifiApiConnector *searchAPI;
    UITapGestureRecognizer *dismissKeybaordTap;
    NSInteger groupStart,addStart,groupLength,addLength,searchStart,searchLength;
    ApiErrorCallback handleError;
    UITextField *alertField;
}
@synthesize header,deviceGroup,deviceAdd,deviceSearch,deviceTable,searchBar,filterBtn,filterState,isSearched,groupData;

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
    
    header.text = [groupData valueForKey:@"name" ];
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
    
    [filterBtn setSelected:NO];
    filterState=1;
    isSearched=NO;
    deviceGroup = [[NSMutableArray alloc] init];
    deviceAdd = [[NSMutableArray alloc] init];
    [DejalBezelActivityView currentActivityView].showNetworkActivityIndicator = YES;
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading."];
    
    searchStart    = 0;
    groupStart   = 0;
    addStart  = 0;
    
    searchLength  = LoadLength;
    groupLength  = LoadLength;
    addLength = LoadLength;
    
    searchAPI = [[unifiApiConnector alloc] initWithUrl:@""
                                  withCompleteCallback:^(NSJSONSerialization *responseJSON,NSString *responseNSString){
                                                  NSLog(@"%@",responseNSString);
                                      for(NSMutableDictionary *json in [responseJSON valueForKey:@"data"]){
                                          
                                          if(filterState==1)
                                              [json setValue:[NSNumber numberWithInteger: 1] forKey:@"switch"];
                                          else
                                              [json setValue:[NSNumber numberWithInteger: 0] forKey:@"switch"];
                                          
                                          [deviceSearch addObject:json];
                                      }
                                      [DejalBezelActivityView removeViewAnimated:YES];
                                      [deviceTable reloadData];
                                  }
                                     withErrorCallback:handleError
                 ];
    
    firstLoad=YES;
    [self loadDeviceInGroupWithLoadmore:NO];
    [self loadDeviceForAddWithLoadmore:NO];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backToParent:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    else if(filterState==1)return [deviceGroup count];
    else return [deviceAdd count];
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
        json = [deviceGroup objectAtIndex:indexPath.row];
        if ([self.deviceGroup count] >= groupLength && indexPath.row == [self.deviceGroup count] - 2)
            [self loadDeviceInGroupWithLoadmore:YES];
        cell.detailTextLabel.text = [json valueForKey:@"ip"];
        [switchView setOn:[[[deviceGroup objectAtIndex:indexPath.row] valueForKey:@"switch"] boolValue] animated:NO];
    }
    else{
        json = [deviceAdd objectAtIndex:indexPath.row];
        if ([self.deviceAdd count] >= addLength && indexPath.row == [self.deviceAdd count] - 2)
            [self loadDeviceForAddWithLoadmore:YES];
        cell.detailTextLabel.text = [json valueForKey:@"mac"];
        [switchView setOn:[[[deviceAdd objectAtIndex:indexPath.row] valueForKey:@"switch"] boolValue] animated:NO];
        // NSLog(@"%@",[[[deviceAdd objectAtIndex:indexPath.row] valueForKey:@"switch"] boolValue] ? @"true" : @"false");
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [switchView initParameter];
    [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [switchView setParameter:[json valueForKey:@"_id"] withKey:@"id"];
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
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    unifiUserProfileViewController * profile = [self.storyboard instantiateViewControllerWithIdentifier:@"unifiUserProfileViewController"];
//    
//    if(isSearched){
//        [profile setUserData:[deviceSearch objectAtIndex:indexPath.row]];
//    }
//    else if(filterState==1){
//        [profile setUserData:[deviceGroup objectAtIndex:indexPath.row]];
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

-(IBAction)filter:(id)sender
{
    
    if(isSearched){
        searchStart     = 0;
        searchLength    = LoadLength;
        deviceSearch      = [[NSMutableArray alloc] init];
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
        [unifiSystemResource
         changeDeviceToGroup:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
                if(isSearched){
                    [[deviceSearch objectAtIndex:[[switchView getParameterByKey:@"index"] intValue]] setValue:[NSNumber numberWithInteger: 1] forKey:@"switch"];
                }
                else if(filterState==1)
                {
                    [[deviceGroup objectAtIndex:[[switchView getParameterByKey:@"index"] intValue]] setValue:[NSNumber numberWithInteger: 1] forKey:@"switch"];
                }
                else {
                    [[deviceAdd objectAtIndex:[[switchView getParameterByKey:@"index"] intValue]] setValue:[NSNumber numberWithInteger: 1] forKey:@"switch"];
                }
                
                [DejalBezelActivityView removeViewAnimated:YES];
            }
            withHandleError:handleError
            fromGroupId: [groupData valueForKey:@"_id" ]
            andUserId:[switchView getParameterByKey:@"id"]
        ];
    }
    else{
        
        [unifiSystemResource
            changeDeviceToGroup:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
                if(isSearched){
                    [[deviceSearch objectAtIndex:[[switchView getParameterByKey:@"index"] intValue]] setValue:[NSNumber numberWithInteger: 0] forKey:@"switch"];
                }
                else if(filterState==1)
                {
                    [[deviceGroup objectAtIndex:[[switchView getParameterByKey:@"index"] intValue]] setValue:[NSNumber numberWithInteger: 0] forKey:@"switch"];
                }
                else {
                    [[deviceAdd objectAtIndex:[[switchView getParameterByKey:@"index"] intValue]] setValue:[NSNumber numberWithInteger: 0] forKey:@"switch"];
                }
                [DejalBezelActivityView removeViewAnimated:YES];
            }
            withHandleError:handleError
            fromGroupId:@"null"
            andUserId:[switchView getParameterByKey:@"id"]
        ];

    }
}

-(void)loadDeviceInGroupWithLoadmore:(bool)flag{
    if(flag){
        groupStart  = groupLength;
        groupLength = groupLength+LoadLength;
    }


    [unifiSystemResource
         getDeviceInGroup:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
             NSLog(@"%@",responseNSString);
             for(NSMutableDictionary *json in [responseJSON valueForKey:@"data"]){
                 [json setValue:[NSNumber numberWithInteger: 1] forKey:@"switch"];
                 [deviceGroup addObject:json];
             }
             if(!firstLoad){
                 [DejalBezelActivityView removeViewAnimated:YES];
                 [deviceTable reloadData];
             }
             firstLoad=false;
         }
         withHandleError:handleError
         fromStart:groupStart
         toLength:groupLength
         andGroupId:[groupData valueForKey:@"_id" ]
     ];
}

-(void)loadDeviceForAddWithLoadmore:(bool)flag{
    if(flag){
        addStart  = addLength;
        addLength = addLength+LoadLength;
    }
    [unifiSystemResource
        getDeviceForAdding:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
            for(NSMutableDictionary *json in [responseJSON valueForKey:@"data"]){
                [json setValue:[NSNumber numberWithInteger: 0] forKey:@"switch"];
                [deviceAdd addObject:json];
            }
            if(!firstLoad){
                [DejalBezelActivityView removeViewAnimated:YES];
                [deviceTable reloadData];
            }
            firstLoad=false;
        }
        withHandleError:handleError
        fromStart:addStart
        toLength:addLength
        andGroupId:[groupData valueForKey:@"_id" ]
    ];
}

-(void)loadSearchDeviceWithLoadmore:(bool)flag{
    if(flag){
        searchStart  = searchLength;
        searchLength = searchLength+LoadLength;
    }
    NSLog(@"%i",filterState);
    if(filterState==1)
    {
        [searchAPI cancel];
        [searchAPI setUrl:[NSString stringWithFormat:@"http://%@/unifi/device-in-group?start=%i&length=%i&search=%@&id=%@",ApiServerAddress,searchStart,searchLength,[searchBar text],[groupData valueForKey:@"_id" ]]];
        [searchAPI loadGetData];
    }
    else{
        [searchAPI cancel];
        [searchAPI setUrl:[NSString stringWithFormat:@"http://%@/unifi/device-for-adding?start=%i&length=%i&search=%@&id=%@",ApiServerAddress,searchStart,searchLength,[searchBar text],[groupData valueForKey:@"_id" ]]];
        [searchAPI loadGetData];
    }
}

- (void)failureView:(unifiFailureViewController *)viewController
       retryWithSel:(SEL)selector{
    
}

-(IBAction)editGroupName:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:[ NSString stringWithFormat:@"Setting \"%@\" Group",[groupData valueForKey:@"name"] ]
                          message:@"Enter new group name"
                          delegate:self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"Continue", nil ];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertField = [alert textFieldAtIndex:0];
    alertField.keyboardType = UIKeyboardTypeAlphabet;
    alertField.text = [groupData valueForKey:@"name" ];
    
    [alert setTag:1];
    [alert show];

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{   if(buttonIndex>0){
        [DejalBezelActivityView currentActivityView].showNetworkActivityIndicator = YES;
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading."];

        [unifiSystemResource
         setGroup:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
             [DejalBezelActivityView removeViewAnimated:YES];
             if([[responseJSON valueForKey:@"code"] intValue ] == 200){
                 header.text = alertField.text;
                 [groupData setValue:alertField.text forKey:@"name" ];
             }
         }
         withHandleError:handleError
         fromId:[groupData valueForKey:@"_id" ]
         withName:alertField.text
         andDownload:[[groupData valueForKey:@"qos_rate_max_down" ]intValue ]
         andUpload:[[groupData valueForKey:@"qos_rate_max_up" ] intValue]
         ];
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleBlackTranslucent;
}
@end
