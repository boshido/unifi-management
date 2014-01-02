//
//  unifiUserViewController.h
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 12/16/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface unifiUserViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    UITapGestureRecognizer *dismissKeybaordTap;
}
@property(retain,nonatomic)IBOutlet UITableView *userTable;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property(retain,nonatomic) IBOutlet UIView *filterView;
@property(retain,nonatomic) NSMutableArray *userOnline,*userOffline,*userSearch;
@property NSInteger filterState;
@property bool isSearched;

-(IBAction)backToParent:(id)sender;
-(IBAction)backToHome:(id)sender;
@end
