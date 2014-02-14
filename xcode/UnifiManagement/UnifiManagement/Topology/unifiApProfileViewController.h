//
//  unifiApProfileViewController.h
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 2/11/2557 BE.
//  Copyright (c) 2557 KMUTNB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface unifiApProfileViewController : UIViewController <UIAlertViewDelegate>
@property(retain,nonatomic) NSString* mac;
@property(retain,nonatomic) IBOutlet UIImageView *apImage;
@property(retain,nonatomic) IBOutlet UILabel *header,*version,*serial,*ip,*userCount,*upTime;
@property(retain,nonatomic) IBOutlet UIScrollView *deviceScrollView;


-(IBAction)editApName:(id)sender;
-(IBAction)restartAp:(id)sender;
@end
