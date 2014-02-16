//
//  unifiNotificationViewController.h
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 2/15/2557 BE.
//  Copyright (c) 2557 KMUTNB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface unifiNotificationViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UIAlertViewDelegate>
@property(retain,nonatomic) IBOutlet UITableView *deviceTable;
@property(retain,nonatomic) NSMutableArray *notificationList;

-(IBAction)backToParent:(id)sender;

@end
