//
//  unifiUserViewController2.h
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 1/17/2557 BE.
//  Copyright (c) 2557 KMUTNB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface unifiDeviceHistoryViewController: UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property(retain,nonatomic)IBOutlet UITableView *historyTable;
@property(retain,nonatomic) IBOutlet UIButton *filterBtn;
@property(retain,nonatomic) NSMutableArray *session,*auth,*historySearch;
@property(retain,nonatomic) NSString *deviceMac;
@property NSInteger filterState;
@property bool isSearched;

-(IBAction)backToParent:(id)sender;
-(IBAction)backToHome:(id)sender;
-(IBAction)filter:(id)sender;
@end
