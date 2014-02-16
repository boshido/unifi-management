//
//  unifiTableViewCell.h
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 1/2/2557 BE.
//  Copyright (c) 2557 KMUTNB. All rights reserved.
//

#import <UIKit/UIKit.h>
#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE
NS_ENUM(NSInteger, CellStyle) {
        ImageWithTextStyle,
        TextWithDetailStyle,
        TextWithTreeDetailColumnStyle,
        TextWithTreeDetailRowStyle
};

@interface unifiTableViewCell : UITableViewCell{
    enum CellStyle cellStyle;
}
@property(retain,nonatomic) UILabel *secondDetailTextLabel;
@property(retain,nonatomic) UILabel *thirdDetailTextLabel;

-(void)setCellStyle:(enum CellStyle)style;
@end
