//
//  unifiUITapGestureRecognizer.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 12/16/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import "unifiUITapGestureRecognizer.h"
@implementation unifiUITapGestureRecognizer
@synthesize parameter;
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
