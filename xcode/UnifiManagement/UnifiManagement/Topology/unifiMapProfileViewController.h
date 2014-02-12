//
//  unifiMapProfileViewController.h
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 2/9/2557 BE.
//  Copyright (c) 2557 KMUTNB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageScrollView.h"

@interface unifiMapProfileViewController : UIViewController
@property(retain,nonatomic) NSString *mapId;
@property(retain,nonatomic) NSString *mapPictureId;
@property(retain,nonatomic) NSString *mapName;
//@property(retain,nonatomic) UIImageView *map;
@property(retain,nonatomic) IBOutlet UILabel *header,*deviceCount,*apCount;
@property(retain,nonatomic) IBOutlet ImageScrollView *scrollView;
@end
