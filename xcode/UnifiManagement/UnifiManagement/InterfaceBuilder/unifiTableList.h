//
//  unifiSettingsView.h
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 2/14/2557 BE.
//  Copyright (c) 2557 KMUTNB. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface unifiTableList : UIView
@property(retain,nonatomic) UILabel *header,*firstColumn,*secondColumn;
@property(retain,nonatomic) UIView *line;
@property NSInteger contentSize;
@property NSInteger gapBetweenRow;
@property  NSInteger subjectColumnX;
@property  NSInteger subjectColumnSize;
@property (nonatomic,setter = setFirstColumnX:) NSInteger firstColumnX;
@property (nonatomic,setter = setSecondColumnX:) NSInteger secondColumnX;
@property (nonatomic,setter = setFirstColumnSize:) NSInteger firstColumnSize;
@property (nonatomic,setter = setSecondColumnSize:) NSInteger secondColumnSize;

-(void)addRowWithSubjectString:(NSString *)subject andFirstColumnView:(UIView*)firstColumnView andSecondColumnView:(UIView*)secondColumnView;
-(void)addRowWithSubjectView:(UIView*)subjectView andFirstColumnView:(UIView*)firstColumnView andSecondColumnView:(UIView*)secondColumnView;

-(void) setFirstColumnX:(NSInteger)value;
-(void) setSecondColumnX:(NSInteger)value;
-(void) setFirstColumnSize:(NSInteger)value;
-(void) setSecondColumnSize:(NSInteger)value;

+(UILabel*)generateUILabelWithTitle:(NSString *)title;
+(UIButton*)generateUIButtonWithTitle:(NSString *)title;
+(UIButton*)generateAccessoryUIButtonWithImagedName:(NSString *)imagename;
@end
