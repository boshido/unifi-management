/*
 * Copyright (c) 2013 Martin Hartl
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "MHTabBarSegue.h"
#import "unifiViewController.h"

@implementation MHTabBarSegue
- (void) perform {
    unifiViewController *tabBarViewController = (unifiViewController *)self.sourceViewController;
    UIViewController *destinationViewController = (UIViewController *) tabBarViewController.destinationViewController;
    
    /*
        tabBarViewController is Root Viewcontroller
        destinationViewController is Destination Viewcontroller
     */
    //remove old viewController
    if (tabBarViewController.oldViewController) {
        [tabBarViewController.oldViewController willMoveToParentViewController:nil];
        [tabBarViewController.oldViewController.view removeFromSuperview];
        [tabBarViewController transitionFromViewController: tabBarViewController.oldViewController toViewController: destinationViewController   // 3
                                                  duration: 0.25 options:0
                                                animations:^{
                                                    destinationViewController.view.frame = tabBarViewController.container.bounds;
                                                    
                                                }
                                                completion:^(BOOL finished) {
                                                    if(tabBarViewController.oldViewController)
                                                        [tabBarViewController.oldViewController removeFromParentViewController];                   // 5
                                                    [destinationViewController didMoveToParentViewController:tabBarViewController];
                                                }];
    }
    
    //initial new viewController
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:1.0];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
//                           forView:destinationViewController.view
//                             cache:YES];
//    
//    
//    [UIView commitAnimations];
    
    
    [tabBarViewController addChildViewController:destinationViewController];
    [tabBarViewController.container addSubview:destinationViewController.view];
    
   
    
    
}

@end
