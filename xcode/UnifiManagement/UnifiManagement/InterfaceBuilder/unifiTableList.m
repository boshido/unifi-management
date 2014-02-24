//
//  unifiSettingsView.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 2/14/2557 BE.
//  Copyright (c) 2557 KMUTNB. All rights reserved.
//

#import "unifiTableList.h"


@implementation unifiTableList{
    
}
@synthesize header,firstColumn,secondColumn,line,contentSize,subjectColumnX,subjectColumnSize,firstColumnX,secondColumnX,gapBetweenRow,firstColumnSize,secondColumnSize;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        subjectColumnX = 10;
        subjectColumnSize = 125;
        firstColumnX = 145;
        secondColumnX = 220;
        gapBetweenRow = 18;
        firstColumnSize = 60;
        secondColumnSize = 60;
        // Initialization code
        header =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 105, 21)];
        header.font = [UIFont systemFontOfSize:12];
        header.textColor = [UIColor whiteColor];
        header.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
        header.textAlignment = NSTextAlignmentLeft;
        
        firstColumn =[[UILabel alloc] initWithFrame:CGRectMake(firstColumnX, 0, firstColumnSize, 21)];
        firstColumn.font = [UIFont systemFontOfSize:12];
        firstColumn.textColor = [UIColor colorWithRed:0.663 green:0.639 blue:0.671 alpha:1.0];
        firstColumn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
        firstColumn.textAlignment = NSTextAlignmentCenter;
        
        secondColumn =[[UILabel alloc] initWithFrame:CGRectMake(secondColumnX, 0, secondColumnSize, 21)];
        secondColumn.font = [UIFont systemFontOfSize:12];
        secondColumn.textColor = [UIColor colorWithRed:0.663 green:0.639 blue:0.671 alpha:1.0];
        secondColumn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
        secondColumn.textAlignment = NSTextAlignmentCenter;
        
        line = [[UIView alloc] initWithFrame:CGRectMake(0, 21, frame.size.width,1)];
        line.backgroundColor = [UIColor colorWithRed:0.663 green:0.639 blue:0.671 alpha:1.0];
        [self addSubview:header];
        [self addSubview:firstColumn];
        [self addSubview:secondColumn];
        [self addSubview:line];
        
        contentSize=22;
    }
    return self;
}
-(void)layoutSubviews{

}

-(void) setFirstColumnX:(NSInteger)value{
    firstColumnX = value;
    firstColumn.frame =CGRectMake(firstColumnX, 0, firstColumnSize, 21);
}
-(void) setSecondColumnX:(NSInteger)value{
    secondColumnX = value;
    secondColumn.frame =CGRectMake(secondColumnX, 0, secondColumnSize, 21);
}
-(void) setFirstColumnSize:(NSInteger)value{
    firstColumnSize = value;
    firstColumn.frame =CGRectMake(firstColumnX, 0, firstColumnSize, 21);
}
-(void) setSecondColumnSize:(NSInteger)value{
    secondColumnSize = value;
    secondColumn.frame =CGRectMake(secondColumnX, 0, secondColumnSize, 21);
}

-(void)addRowWithSubjectString:(NSString *)subject andFirstColumnView:(UIView*)firstColumnView andSecondColumnView:(UIView*)secondColumnView{

    
    UILabel *subjectView =[[UILabel alloc] initWithFrame:CGRectMake( subjectColumnX , contentSize, subjectColumnSize, 21)];
    subjectView.font = [UIFont systemFontOfSize:12];
    subjectView.textColor = [UIColor whiteColor];
    subjectView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
    subjectView.textAlignment = NSTextAlignmentLeft;
    subjectView.text=subject;
    
    firstColumnView.frame = CGRectMake(firstColumnX, contentSize, firstColumnSize, 21);
    secondColumnView.frame = CGRectMake(secondColumnX, contentSize, secondColumnSize, 21);
    
    [self addSubview:subjectView];
    [self addSubview:firstColumnView];
    [self addSubview:secondColumnView];
    contentSize +=gapBetweenRow;
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, contentSize+13);
}
-(void)addRowWithSubjectView:(UIView*)subjectView andFirstColumnView:(UIView*)firstColumnView andSecondColumnView:(UIView*)secondColumnView{
    
    subjectView.frame = CGRectMake( subjectColumnX , contentSize, subjectColumnSize, 21);
    firstColumnView.frame = CGRectMake(firstColumnX, contentSize, firstColumnSize, 21);
    secondColumnView.frame = CGRectMake(secondColumnX, contentSize, secondColumnSize, 21);
    
    [self addSubview:subjectView];
    [self addSubview:firstColumnView];
    [self addSubview:secondColumnView];
    contentSize +=gapBetweenRow;
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, contentSize+13);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+(UILabel*)generateUILabelWithTitle:(NSString *)title{
    
    UILabel *subjectView =[[UILabel alloc] init];
    subjectView.font = [UIFont systemFontOfSize:12];
    subjectView.textColor = [UIColor whiteColor];
    subjectView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
    subjectView.textAlignment = NSTextAlignmentLeft;
    subjectView.text=title;
    
    return subjectView;
}
+(UIButton*)generateUIButtonWithTitle:(NSString *)title{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.adjustsImageWhenHighlighted=true;
    button.titleLabel.font =[UIFont systemFontOfSize:12];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.216 green:0.698 blue:0.808 alpha:1.0] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.216 green:0.698 blue:0.808 alpha:0.5] forState:UIControlStateHighlighted];
    
    return button;
}
+(UIButton*)generateAccessoryUIButtonWithImagedName:(NSString *)imagename{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.adjustsImageWhenHighlighted=true;
    [button setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
    button.titleLabel.font =[UIFont systemFontOfSize:12];
    [button setTitleColor:[UIColor colorWithRed:0.216 green:0.698 blue:0.808 alpha:1.0] forState:UIControlStateNormal];
    
    return button;
}
@end
