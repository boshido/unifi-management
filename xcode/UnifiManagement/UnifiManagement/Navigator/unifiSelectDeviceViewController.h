//
//  unifiSelectDeviceViewController.h
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 1/16/2557 BE.
//  Copyright (c) 2557 KMUTNB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "unifiFailureViewController.h"

@protocol unifiSelectDeviceViewControllerDelegate;

@interface unifiSelectDeviceViewController: UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,unifiFailureViewControllerDelegate>
@property(retain,nonatomic) NSJSONSerialization *userData;
@property(retain,nonatomic) IBOutlet UITableView *deviceTable;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property(retain,nonatomic) IBOutlet UIButton *filterBtn;
@property(retain,nonatomic) NSMutableArray *deviceOnline,*deviceOffline,*deviceSearch;
@property NSInteger filterState;
@property bool isSearched;

-(IBAction)backToParent:(id)sender;
-(IBAction)backToHome:(id)sender;
-(IBAction)filter:(id)sender;

@property(weak,nonatomic) id<unifiSelectDeviceViewControllerDelegate> delegate;

@end


@protocol unifiSelectDeviceViewControllerDelegate<NSObject>
- (void)unifiSelectDeviceView:(unifiSelectDeviceViewController *)viewController
     finishAddDevice:(BOOL)sign;
@end
