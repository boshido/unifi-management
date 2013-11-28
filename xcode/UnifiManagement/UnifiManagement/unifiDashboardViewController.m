//
//  unifiDashboardViewController.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 11/26/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import "unifiDashboardViewController.h"
#import "unifiGlobalVariable.h"
@interface unifiDashboardViewController ()
@end

@implementation unifiDashboardViewController
@synthesize ap;
@synthesize user;
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
    for(UIButton *button in self.buttons){
        //[button setTitle:@"hahaha" forState:UIControlStateNormal];
        
        // Create the animation object, specifying the position property as the key path.
        CAKeyframeAnimation * theAnimation;
        theAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
        CGMutablePathRef thePath = CGPathCreateMutable();
        switch(button.tag){
            case 0:
                CGPathMoveToPoint(thePath,NULL,160.0,335);
                CGPathAddCurveToPoint(thePath,NULL,126,335,
                                      89,317,
                                      59,263);
                break;
            case 1:
                CGPathMoveToPoint(thePath,NULL,160.0,335);
                CGPathAddCurveToPoint(thePath,NULL,126,335,
                                      106,325,
                                      89,317);
                break;
            case 2:
                break;
            case 3:
                CGPathMoveToPoint(thePath,NULL,160.0,335);
                CGPathAddCurveToPoint(thePath,NULL,195,335,
                                      215,325,
                                      232,317);
                break;
            case 4:
                CGPathMoveToPoint(thePath,NULL,160.0,335);
                CGPathAddCurveToPoint(thePath,NULL,194,335,
                                      232,317,
                                      261,263);
                break;
        }
        
        
        theAnimation.duration=0.5;
        // Add path to animation
        theAnimation.path=thePath;
        // Add the animation to the layer.
        [button.layer addAnimation:theAnimation forKey:@"position"];
        
        __block bool flag = NO;
        
        ApiCallbackComplete apCallback = ^(NSJSONSerialization *response){
            NSInteger connected =[[[response valueForKey:@"data"] valueForKey:@"connected"] intValue];
            NSInteger disconnected =[[[response valueForKey:@"data"] valueForKey:@"disconnected"] intValue];
            apCount.text = [NSString stringWithFormat:@"%i / %i",connected,connected+disconnected];
            
            if(flag){
                
                //[self dismissViewControllerAnimated:NO completion:nil];
                NSLog(@"%@",[NSString stringWithFormat:@"%i / %i",connected,connected+disconnected]);
                
            }
            flag = YES;
        };
        ApiCallbackComplete userCallback = ^(NSJSONSerialization *response){
            NSInteger authorized =[[[response valueForKey:@"data"] valueForKey:@"authorized"] intValue];
            NSInteger non_authorized =[[[response valueForKey:@"data"] valueForKey:@"non_authorized"] intValue];
            userCount.text = [NSString stringWithFormat:@"%i / %i",authorized,authorized+non_authorized];
            
            if(flag){
                
                //[self dismissViewControllerAnimated:NO completion:nil];
                NSLog(@"%@",[NSString stringWithFormat:@"%i / %i",authorized,authorized+non_authorized]);
                
            }
            flag = YES;
        };
        
        [unifiApResource getApCount:apCallback];
        [unifiUserResource getUserCount:userCallback];

        /*
         Example Animation
         CABasicAnimation *theAnimation;
         
         theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
         theAnimation.duration=1.0;
         theAnimation.repeatCount=HUGE_VALF;
         theAnimation.autoreverses=YES;
         theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
         theAnimation.toValue=[NSNumber numberWithFloat:0.0];
         [button.layer addAnimation:theAnimation forKey:@"animateOpacity"];
         
         CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
         pulseAnimation.duration = 1;
         pulseAnimation.toValue = [NSNumber numberWithFloat:0.9];
         pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
         pulseAnimation.autoreverses = YES;
         pulseAnimation.repeatCount = FLT_MAX;
         
         [button.layer addAnimation:pulseAnimation forKey:nil];
         */
    }
    
//    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"]]];
//    [chart loadRequest:urlRequest];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)willMoveToParentViewController:(UIViewController *)tmp{
    // Start
    NSLog(@"Hoho");
}

-(void)didMoveToParentViewController:(UIViewController *)parent{
    // End
    NSLog(@"hahaa");
}
@end
