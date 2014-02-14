//
//  unifiSelectDeviceViewController.h
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 1/16/2557 BE.
//  Copyright (c) 2557 KMUTNB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface unifiDeviceViewController: UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property(retain,nonatomic) NSJSONSerialization *userData;
@property(retain,nonatomic) IBOutlet UITableView *deviceTable;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property(retain,nonatomic) IBOutlet UIButton *filterBtn;
@property(retain,nonatomic) NSMutableArray *deviceOnline,*deviceOffline,*deviceSearch;
@property NSInteger filterState;
@property bool isSearched;

-(IBAction)showBlockedDevice:(id)sender;
-(IBAction)backToParent:(id)sender;
-(IBAction)backToHome:(id)sender;
-(IBAction)filter:(id)sender;


@end