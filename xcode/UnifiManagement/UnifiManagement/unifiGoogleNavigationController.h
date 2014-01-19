//
//  unifiGoogleNavigationController.h
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 11/28/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol unifiGoogleNavigationControllerDelegate;
@interface unifiGoogleNavigationController : UINavigationController

@property (weak,nonatomic) id<unifiGoogleNavigationControllerDelegate> tokenDelegate;

@end
@protocol unifiGoogleNavigationControllerDelegate <NSObject>

- (void)unifiGoogleNavigation:(unifiGoogleNavigationController *)viewController
 finishWithRefreshToken:(NSString*)refreshToken;
@end
