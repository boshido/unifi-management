//
//  unifiViewController.m
//  UnifiManagement
//
//  Created by Boshido on 11/20/56 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import "unifiViewController.h"

@interface unifiViewController ()

@end

@implementation unifiViewController{
    NSMutableDictionary *_viewControllersByIdentifier;
}

typedef void(^ApiCallback)(NSJSONSerialization *response);
@synthesize apCount;
@synthesize userCount;
- (void)viewDidLoad
{
    [super viewDidLoad];
    _viewControllersByIdentifier = [NSMutableDictionary dictionary];
	// Do any additional setup after loading the view, typically from a nib.
        
    
//    UISwipeGestureRecognizer * recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestureToMap)];
//    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
//    [self.view addGestureRecognizer:recognizer];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[_viewControllersByIdentifier allKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        if (![self.destinationIdentifier isEqualToString:key]) {
            [_viewControllersByIdentifier removeObjectForKey:key];
        }
    }];

}
//-(void)gestureToMap{
//    NSLog(@"TEST Gesture");
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
//    unifiSplashViewController *second2 = [storyboard instantiateViewControllerWithIdentifier:@"unifiSplashViewController"];
//    second2.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [self presentViewController:second2 animated:NO completion:nil];
//}
//

/* ---------------------------  TEST  ------------------------------*/

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.childViewControllers.count < 1) {
        [self performSegueWithIdentifier:@"DashBoard" sender:[self.menuBarButtons objectAtIndex:0]];
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    self.destinationViewController.view.frame = self.container.bounds;
}


#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if (![segue isKindOfClass:[MHTabBarSegue class]]) {
        [super prepareForSegue:segue sender:sender];
        return;
    }
    
    self.oldViewController = self.destinationViewController;
    
    //if view controller isn't already contained in the viewControllers-Dictionary
    if (![_viewControllersByIdentifier objectForKey:segue.identifier]) {
        [_viewControllersByIdentifier setObject:segue.destinationViewController forKey:segue.identifier];
    }
    
    for (UIButton *aButton in self.menuBarButtons) {
        [aButton setSelected:NO];
    }
    
    UIButton *button = (UIButton *)sender;
    [button setSelected:YES];
    self.destinationIdentifier = segue.identifier;
    self.destinationViewController = [_viewControllersByIdentifier objectForKey:self.destinationIdentifier];
    
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([self.destinationIdentifier isEqual:identifier]) {
        //Dont perform segue, if visible ViewController is already the destination ViewController
        return NO;
    }
    
    return YES;
}



//
//- (void) cycleFromViewController: (UIViewController*) oldC
//                toViewController: (UIViewController*) newC
//{
//    [oldC willMoveToParentViewController:nil];                        // 1
//    [self addChildViewController:newC];
//    
//    newC.view.frame = [self newViewStartFrame];                       // 2
//    CGRect endFrame = [self oldViewEndFrame];
//    
//    [self transitionFromViewController: oldC toViewController: newC   // 3
//                              duration: 0.25 options:0
//                            animations:^{
//                                newC.view.frame = oldC.view.frame;                       // 4
//                                oldC.view.frame = endFrame;
//                            }
//                            completion:^(BOOL finished) {
//                                [oldC removeFromParentViewController];                   // 5
//                                [newC didMoveToParentViewController:self];
//                            }];
//}
@end
