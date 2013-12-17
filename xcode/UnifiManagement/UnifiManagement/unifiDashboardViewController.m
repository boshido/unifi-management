//
//  unifiDashboardViewController.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 11/26/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import "unifiDashboardViewController.h"
#import "unifiGoogleNavigationController.h"
#import "unifiGlobalVariable.h"
#import "unifiApResource.h"
#import "unifiUserResource.h"
#import "UITabBarController+unifiTabBarWithHide.h"


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

    //UIImage *image = [UIImage imageNamed:@"Logo.png"];
    //self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image] ;
    
    
    // Do any additional setup after loading the view.
    // Create Loading Spinner
    spinner = [[TJSpinner alloc] initWithSpinnerType:kTJSpinnerTypeActivityIndicator];
    [spinner setColor:[UIColor colorWithRed:17/255.00 green:181/255.00 blue:255.00/255.00 alpha:1.0]];
    [spinner setStrokeWidth:20];
    [spinner setInnerRadius:6];
    [spinner setOuterRadius:15];
    [spinner setNumberOfStrokes:8];
    spinner.hidesWhenStopped = YES;
    [spinner setPatternStyle:TJActivityIndicatorPatternStylePetal];
    spinner.center = CGPointMake(68, 90);
    [spinner startAnimating];
    [loadingView addSubview:spinner];

    // Read the XML file.
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"refresh_token.plist"];
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *value = [plistDict objectForKey:@"refresh_token"];
    
    if (![value isEqualToString:@""] && value != NULL) {
        [unifiGlobalVariable sharedGlobalData].refreshToken = value;
    }
    else{
        [self setLoadingMode:YES];
    }

    
    for(UIButton *button in self.buttons){
        // Create the animation object, specifying the position property as the key path.
        CAKeyframeAnimation * theAnimation;
        theAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
        CGMutablePathRef thePath = CGPathCreateMutable();
//        switch(button.tag){
//            case 0:
//                CGPathMoveToPoint(thePath,NULL,160.0,335);
//                CGPathAddCurveToPoint(thePath,NULL,126,335,
//                                      89,317,
//                                      59,263);
//                break;
//            case 1:
//                CGPathMoveToPoint(thePath,NULL,160.0,335);
//                CGPathAddCurveToPoint(thePath,NULL,126,335,
//                                      106,325,
//                                      89,317);
//                break;
//            case 2:
//                break;
//            case 3:
//                CGPathMoveToPoint(thePath,NULL,160.0,335);
//                CGPathAddCurveToPoint(thePath,NULL,195,335,
//                                      215,325,
//                                      232,317);
//                break;
//            case 4:
//                CGPathMoveToPoint(thePath,NULL,160.0,335);
//                CGPathAddCurveToPoint(thePath,NULL,194,335,
//                                      232,317,
//                                      261,263);
//                break;
//        }
        
        //[self.navigationController setNavigationBarHidden:!self.navigationController.navigationBar.hidden animated:YES];
        
        theAnimation.duration=0.5;
        // Add path to animation
        theAnimation.path=thePath;
        // Add the animation to the layer.
        [button.layer addAnimation:theAnimation forKey:@"position"];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated{
    
    NSLog(@"View Appear");
    if(![[unifiGlobalVariable sharedGlobalData].refreshToken isEqualToString:@""]){
        [self setLoadingMode:false];
        [self loadDashBoardInfo];
        autoLoad = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(loadDashBoardInfo) userInfo:nil repeats:YES];
    }
    else{
        [self setLoadingMode:YES];
    }
    
}
-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"View Dissapear");
    [autoLoad invalidate];
    autoLoad = Nil;
}
//-(void)willMoveToParentViewController:(UIViewController *)tmp{
//    // Start
//    NSLog(@"Hoho");
//}
//
//-(void)didMoveToParentViewController:(UIViewController *)parent{
//    // End
//    NSLog(@"hahaas");
//}
-(IBAction)toSignIn:(id)sender{
    unifiGoogleNavigationController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"unifiGoogleNavigationController"];
        [self presentViewController:loginView animated:YES completion:nil];
}


-(void)loadDashBoardInfo{
    __block bool flag = NO;
    
    ApiCallbackComplete apCallback = ^(NSJSONSerialization *responseJSON,NSString * responseNSString){
        NSInteger connected =[[[responseJSON valueForKey:@"data"] valueForKey:@"connected"] intValue];
        NSInteger disconnected =[[[responseJSON valueForKey:@"data"] valueForKey:@"disconnected"] intValue];
        apCount.text = [NSString stringWithFormat:@"%i / %i",connected,connected+disconnected];
        
        if(flag){
            //[self dismissViewControllerAnimated:NO completion:nil];
            NSLog(@"%@",[NSString stringWithFormat:@"%i / %i",connected,connected+disconnected]);
            [self setLoadingMode:NO];
        }
        flag = YES;
    };
    ApiCallbackComplete userCallback = ^(NSJSONSerialization *responseJSON,NSString * responseNSString){
        NSInteger authorized =[[[responseJSON valueForKey:@"data"] valueForKey:@"authorized"] intValue];
        NSInteger non_authorized =[[[responseJSON valueForKey:@"data"] valueForKey:@"non_authorized"] intValue];
        userCount.text = [NSString stringWithFormat:@"%i / %i",authorized,authorized+non_authorized];
        
        if(flag){
            //[self dismissViewControllerAnimated:NO completion:nil];
            NSLog(@"%@",[NSString stringWithFormat:@"%i / %i",authorized,authorized+non_authorized]);
            [self setLoadingMode:NO];
        }
        flag = YES;
    };
    [unifiApResource getApCount:apCallback];
    [unifiUserResource getUserCount:userCallback];
}
-(void)setLoadingMode:(BOOL)flag{
    
    /*
     CABasicAnimation *theAnimation;
     
     theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
     theAnimation.duration=1.0;
     theAnimation.repeatCount=HUGE_VALF;
     theAnimation.autoreverses=YES;
     theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
     theAnimation.toValue=[NSNumber numberWithFloat:0.0];
     [loadingView.layer addAnimation:theAnimation forKey:@"animateOpacity"];
     
     CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
     pulseAnimation.duration = 1;
     pulseAnimation.toValue = [NSNumber numberWithFloat:0.9];
     pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
     pulseAnimation.autoreverses = YES;
     pulseAnimation.repeatCount = FLT_MAX;
     
     [loadingView.layer addAnimation:pulseAnimation forKey:nil];
     */
    UIView *source,*destination;
    
    if(flag){
        source = infoView;
        destination = loadingView;
        [loading setAlpha:0];
        [signIn setAlpha:1];
        [spinner stopAnimating];
    }
    else{
        source = loadingView;
        destination = infoView;
        [loading setAlpha:1];
        [signIn setAlpha:0];
        [spinner startAnimating];
    }
    
    for(UIButton *button in self.buttons){
        [button setEnabled:!flag];
    }
    for(UIButton *button in [[self.tabBarController tabBar] items]){
        [button setEnabled:!flag];
    }
    
    [UIView animateWithDuration:0.5
                            delay:0.0  /* do not add a delay because we will use performSelector. */
                            options:UIViewAnimationOptionCurveEaseOut
                            animations:^ {
                                source.alpha = 0.0;
                            }
                            completion:^(BOOL finished) {
                               // [myLabel1 removeFromSuperview];
                            }];
    [UIView animateWithDuration:0.5
                          delay:0.0  /* do not add a delay because we will use performSelector. */
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^ {
                         destination.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         // [myLabel1 removeFromSuperview];
                     }];

}
@end
