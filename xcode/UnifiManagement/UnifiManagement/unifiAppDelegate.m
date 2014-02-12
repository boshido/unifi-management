//
//  unifiAppDelegate.m
//  UnifiManagement
//
//  Created by Boshido on 11/20/56 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import "unifiAppDelegate.h"
#import "unifiGoogleResource.h"

@implementation unifiAppDelegate
@synthesize window,splashView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    // Override point for customization after application launch.
    
    UIImage* BarBackground = [UIImage imageNamed:@"BlackBG.png"];
    // For Navigation Bar
    [[UINavigationBar appearance] setBackgroundImage:BarBackground forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackOpaque];
    
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"BlackBG.png"]];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"BlackBG.png"]];
    // For Tab Bar
//    [[UITabBar appearance] setBackgroundImage:BarBackground];
//    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"BarBG.png"]];
    
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    UIStoryboard *storyboard = [self.window.rootViewController storyboard];
    [unifiGoogleResource isNeedForLogin:^{
        [self.window.rootViewController  presentViewController:[storyboard instantiateViewControllerWithIdentifier:@"unifiSplashViewController"] animated:NO completion:nil];
    }];
//    
//    splashView = [storyboard instantiateViewControllerWithIdentifier:@"unifiSplashViewController"];
//    [self.window.rootViewController presentViewController:splashView animated:NO completion:nil];
       //[self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    //}];
    
//    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"refresh_token.plist"];
//    
//    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
//    NSString *value = [plistDict objectForKey:@"refresh_token"];
//    
//    if (![value isEqualToString:@""] && value != NULL) {
//        [unifiGlobalVariable sharedGlobalData].refreshToken = value;
//        NSLog(@"%@", [unifiGlobalVariable sharedGlobalData].refreshToken );
//    }
//    else{
//        
//        [self.window.rootViewController  presentViewController:[storyboard instantiateViewControllerWithIdentifier:@"unifiSplashViewController"] animated:NO completion:nil];
//    }
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

@end
