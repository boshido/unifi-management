//
//  unifiUITapGestureRecognizer.h
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 12/16/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface unifiUITapGestureRecognizer : UITapGestureRecognizer
@property(strong,nonatomic)NSMutableDictionary *parameter;
-(void) initParameter;
-(void) setParameter:(id)object withKey:(NSString *)key;
-(id) getParameterByKey:(NSString *)key;
@end
