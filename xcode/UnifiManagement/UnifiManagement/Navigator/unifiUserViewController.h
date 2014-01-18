//
//  unifiUserViewController2.h
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 1/17/2557 BE.
//  Copyright (c) 2557 KMUTNB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface unifiUserViewController: UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property(retain,nonatomic)IBOutlet UITableView *userTable;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property(retain,nonatomic) NSMutableArray *userOnline,*userOffline,*userSearch;
@property NSInteger filterState;
@property bool isSearched;

-(IBAction)backToParent:(id)sender;
-(IBAction)backToHome:(id)sender;
-(IBAction)filter:(id)sender;
@end
