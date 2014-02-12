//
//  unifiButton.h
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 2/11/2557 BE.
//  Copyright (c) 2557 KMUTNB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface unifiButton : UIButton
@property(strong,nonatomic)NSMutableDictionary *parameter;
-(void) initParameter;
-(void) setParameter:(id)object withKey:(NSString *)key;
-(id) getParameterByKey:(NSString *)key;

@end
