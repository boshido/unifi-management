//
//  unifiTabViewController.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 11/29/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import "unifiTabViewController.h"
#import "unifiGlobalVariable.h"
#import "unifiSystemResource.h"
#import "unifiGlobalVariable.h"
@interface unifiTabViewController ()

@end

@implementation unifiTabViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.delegate = self;
//    unifiSettingViewController * tmp = [self.viewControllers objectAtIndex:2];
//    tmp.delegate =  [self.viewControllers objectAtIndex:0];
    
//    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
//    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
//    [self.view addGestureRecognizer:swipeLeft];
//    swipeLeft.delegate = self;
//    
//    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
//    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
//    [self.view addGestureRecognizer:swipeRight];
//    swipeRight.delegate = self;
    [self loadNotification];
    [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(loadNotification) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadNotification{
    [unifiSystemResource
     getNotification:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
         
         NSLog(@"%@",[[responseJSON valueForKey:@"data"] valueForKey:@"notification"]);
         [[[[self tabBar] items] objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%i",[[[responseJSON valueForKey:@"data"] valueForKey:@"notification"] intValue]]];
     }
     withHandleError:^(NSError *error) {
         
     }
     withTokenId:[unifiGlobalVariable sharedGlobalData].iosToken
     ];
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    NSLog(@"Change Tab");
    [tabBarController.selectedViewController.navigationController popToRootViewControllerAnimated:NO];
    NSArray *tabViewControllers = tabBarController.viewControllers;
    UIView * fromView = tabBarController.selectedViewController.view;
    UIView * toView = viewController.view;
    if (fromView == toView)
        return false;
    NSUInteger fromIndex = [tabViewControllers indexOfObject:tabBarController.selectedViewController];
    NSUInteger toIndex = [tabViewControllers indexOfObject:viewController];

    [UIView transitionFromView:fromView
                        toView:toView
                      duration:0.3
                       options: toIndex > fromIndex ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight
                    completion:^(BOOL finished) {
                        if (finished) {
                            tabBarController.selectedIndex = toIndex;
                            
                        }
                    }];
    
    return true;
}


@end
