//
//  unifiProfileViewController.h
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 12/31/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "unifiSelectDeviceViewController.h"

@interface unifiProfileViewController : UIViewController<unifiSelectDeviceViewControllerDelegate>{
    NSInteger contentSize;
}
@property(retain,nonatomic) NSJSONSerialization *userData;
@property(retain,nonatomic) IBOutlet UIView *profileView,*typeBar;
@property(retain,nonatomic) IBOutlet UIScrollView *scrollView;
@property(retain,nonatomic) IBOutlet UIImageView *profilePicture;
@property(retain,nonatomic) IBOutlet UILabel *profileName,*profileEmail,*deviceCount;
@property(retain,nonatomic) NSMutableArray *onlineDevice,*offlineDevice;

-(IBAction)addDevice:(id)sender;
@end
