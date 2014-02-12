//
//  unifiMapViewController.h
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 2/8/2557 BE.
//  Copyright (c) 2557 KMUTNB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface unifiMapViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(retain,nonatomic) IBOutlet UITableView *mapTable;
@property(retain,nonatomic) NSMutableArray *mapList;
@end
