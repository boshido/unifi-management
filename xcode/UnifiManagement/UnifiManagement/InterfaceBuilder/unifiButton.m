//
//  unifiButton.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 2/11/2557 BE.
//  Copyright (c) 2557 KMUTNB. All rights reserved.
//

#import "unifiButton.h"

@implementation unifiButton
@synthesize parameter;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void) initParameter{
    parameter =[[NSMutableDictionary alloc] init];
}
-(void) setParameter:(id)object withKey:(NSString *)key{
    [parameter setValue:object forKey:key];
}
-(id) getParameterByKey:(NSString *)key{
    return [parameter valueForKey:key];
}
@end
