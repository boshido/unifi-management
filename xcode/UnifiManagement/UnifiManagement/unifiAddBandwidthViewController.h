//
//  unifiAddBandwidthViewController.h
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 2/15/2557 BE.
//  Copyright (c) 2557 KMUTNB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "unifiFailureViewController.h"

@interface unifiAddBandwidthViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,unifiFailureViewControllerDelegate,UIAlertViewDelegate>
@property(retain,nonatomic) NSJSONSerialization *groupData;
@property(retain,nonatomic) IBOutlet UILabel *header;
@property(retain,nonatomic) IBOutlet UITableView *deviceTable;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property(retain,nonatomic) IBOutlet UIButton *filterBtn;
@property(retain,nonatomic) NSMutableArray *deviceGroup,*deviceAdd,*deviceSearch;
@property NSInteger filterState;
@property bool isSearched;

-(IBAction)backToParent:(id)sender;
-(IBAction)backToHome:(id)sender;
-(IBAction)filter:(id)sender;

@end
