//
//  unifiTableViewCell.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 1/2/2557 BE.
//  Copyright (c) 2557 KMUTNB. All rights reserved.
//

#import "unifiTableViewCell.h"

@implementation unifiTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews {
    [super layoutSubviews];
    switch (cellStyle){
        case ImageWithTextStyle :
            self.imageView.frame = CGRectMake(20.0f , 4.0f, 35.0f, 35.0f);
            [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [self.imageView.layer setCornerRadius:17.5f];
            [self.imageView.layer setMasksToBounds: YES];
            [self.imageView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
            [self.imageView.layer setBorderWidth:0.3f];
            self.textLabel.frame = CGRectMake(75.0f, 4.0f, 200, 35);
            self.textLabel.font = [UIFont systemFontOfSize:13];
            self.textLabel.textColor = [UIColor colorWithRed:0.435 green:0.443 blue:0.475 alpha:1.0];
            break;
        case TextWithDetailStyle:
            self.imageView.frame = CGRectMake(20.0f , 4.0f, 35.0f, 35.0f);
            
            self.textLabel.frame = CGRectMake(75.0f, 4.0f, 150, 20);
            self.textLabel.font = [UIFont systemFontOfSize:13];
            self.textLabel.textColor = [UIColor colorWithRed:0.435 green:0.443 blue:0.475 alpha:1.0];
            self.detailTextLabel.frame = CGRectMake(75.0f,20.0f, 150, 20);
            self.detailTextLabel.font = [UIFont systemFontOfSize:12];
            self.detailTextLabel.textColor = [UIColor colorWithRed:0.663 green:0.639 blue:0.671 alpha:1.0];
            
            break;
            
    }
}

-(void)setCellStyle:(enum CellStyle)style{
    cellStyle=style;
}
@end
