//
//  unifiUserViewController2.h
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 1/17/2557 BE.
//  Copyright (c) 2557 KMUTNB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "unifiFailureViewController.h"

@interface unifiUserListViewController: UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property(retain,nonatomic)IBOutlet UITableView *userTable;
@property(weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property(retain,nonatomic) NSMutableArray *userList,*userSearch;
@property(retain,nonatomic) NSString *deviceMac,*deviceHostname;
@property bool isSearched;

-(IBAction)backToParent:(id)sender;
-(IBAction)backToHome:(id)sender;
@end
