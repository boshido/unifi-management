//
//  unifiSettingsView.h
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 2/14/2557 BE.
//  Copyright (c) 2557 KMUTNB. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface unifiSettingsView : UIView
@property(retain,nonatomic) UILabel *header,*firstColumn,*secondColumn;
@property(retain,nonatomic) UIView *line;


-(void)addRowWithSubject:(NSString *)subject andFirstColumnView:(UIView*)firstColumnView andSecondColumnView:(UIView*)secondColumnView;

+(UIButton*)generateUIButtonWithTitle:(NSString *)title;
+(UIButton*)generateAccessoryUIButtonWithImagedName:(NSString *)imagename;
@end
