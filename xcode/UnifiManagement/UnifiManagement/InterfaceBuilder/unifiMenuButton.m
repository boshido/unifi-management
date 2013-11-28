//
//  unifiMenuButton.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 11/25/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import "unifiMenuButton.h"

@implementation unifi_MenuButton

- (void)initView{
    self.layer.cornerRadius = 15;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius = 3;
    self.layer.shadowOffset = CGSizeMake(1.5f, 1.5f);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initView];
    }
    return self;
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    self.contentEdgeInsets = UIEdgeInsetsMake(1.0,-1.0,0.0,-1.0);
    self.layer.shadowOffset = CGSizeMake(0.5f, 0.5f);
    self.layer.shadowOpacity = 0.5;
    
    
    [super touchesBegan:touches withEvent:event];
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.contentEdgeInsets = UIEdgeInsetsMake(0.0,0.0,0.0,0.0);
    self.layer.shadowOffset = CGSizeMake(1.5f, 1.5f);
    self.layer.shadowOpacity = 0.5;
    
    [super touchesEnded:touches withEvent:event];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
