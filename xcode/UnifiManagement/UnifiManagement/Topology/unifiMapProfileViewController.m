//
//  unifiMapProfileViewController.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 2/9/2557 BE.
//  Copyright (c) 2557 KMUTNB. All rights reserved.
//

#import "unifiMapProfileViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "unifiSystemResource.h"
#import "unifiApProfileViewController.h"
#import "unifiButton.h"

@interface unifiMapProfileViewController ()

@end

@implementation unifiMapProfileViewController
@synthesize mapId,mapName,mapPictureId,header,deviceCount,apCount,scrollView;
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
    
    //[[UIScreen mainScreen] bounds].size.height- 100)
    [scrollView initial];
//    scrollView.clipsToBounds = YES;
//    scrollView.scrollEnabled = YES;
//    scrollView.pagingEnabled = YES;
//    scrollView.delaysContentTouches = NO;
//    scrollView.canCancelContentTouches = NO;
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [scrollView displayImage:[NSString stringWithFormat:@"http://%@/unifi/map?id=%@",ApiServerAddress,mapPictureId]
     completed:^{
         [unifiSystemResource
          getMapApList:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
              if([[responseJSON valueForKey:@"code"] intValue] == 200){
                  [[self.scrollView.zoomView subviews]
                   makeObjectsPerformSelector:@selector(removeFromSuperview)];
                  NSInteger apOnline=0,apOffline=0,mapCount=0;
                  for(NSJSONSerialization *json in [[[responseJSON valueForKey:@"data"] objectAtIndex:0] valueForKey:@"ap"]){
                      
                      NSString *unifiPicture;
                      if([[json valueForKey:@"state"] intValue] == 1){
                          unifiPicture=@"UnifiOnlineGrowIcon";
                          apOnline++;
                          mapCount+=[[json valueForKey:@"num_sta"] intValue];
                      }
                      else {unifiPicture=@"UnifiOfflineGrowIcon";apOffline++;}
                     
                      unifiButton *unifi = [[unifiButton alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
                      unifi.center = CGPointMake([[json valueForKey:@"x"] floatValue], [[json valueForKey:@"y"] floatValue]);
                      [unifi setImage:[self imageWithImage:[UIImage imageNamed:unifiPicture] scaledToSize:CGSizeMake(200, 200)] forState:UIControlStateNormal];
                      
                      [unifi initParameter];
                      [unifi setParameter:[json valueForKey:@"mac"] withKey:@"mac"];

                      [unifi addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
                      [self.scrollView.zoomView addSubview:unifi];
                      
                      UILabel *deviceName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 600, 200)];
                      deviceName.center = CGPointMake([[json valueForKey:@"x"] floatValue], [[json valueForKey:@"y"] floatValue]+140);
                      deviceName.text = [json valueForKey:@"name"];
                      deviceName.backgroundColor = [UIColor clearColor];
                      deviceName.font = [UIFont systemFontOfSize:50];
                      deviceName.textAlignment = NSTextAlignmentCenter;
                      
                      [self.scrollView.zoomView addSubview:deviceName];
                      
                      UILabel *count = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 600, 200)];
                      count.center = CGPointMake([[json valueForKey:@"x"] floatValue], [[json valueForKey:@"y"] floatValue]);
                      count.text = [NSString stringWithFormat:@"%i",[[json valueForKey:@"state"] intValue] == 1 ? [[json valueForKey:@"num_sta"] intValue] : 0];
                      count.backgroundColor = [UIColor clearColor];
                      count.font = [UIFont systemFontOfSize:50];
                      count.textAlignment = NSTextAlignmentCenter;
                      
                      [self.scrollView.zoomView addSubview:count];
                      
                  }
                  deviceCount.text = [NSString stringWithFormat:@"Devices : %i",mapCount];
                  apCount.text = [NSString stringWithFormat:@"AP : %i/%i",apOnline,apOnline+apOffline];
              }
          }
          withHandleError:^(NSError *error) {
              
          }
          fromMapId:mapId
          ];
         
     }];
    NSLog(@"%@",mapName);
    header.text = mapName;
    
   
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)click:(id)sender
{
    unifiButton *button = (unifiButton*)sender;
    unifiApProfileViewController *apProfile = [[self storyboard] instantiateViewControllerWithIdentifier:@"unifiApProfileViewController"];
    apProfile.mac =[button getParameterByKey:@"mac"];
    
    [self.navigationController pushViewController:apProfile animated:YES];
}

-(IBAction)backToParent:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (UIImage *) mergeImage:(UIImage *)firstImg andImage:(UIImage *)secondImg withPoint:(CGPoint)point{
    
    CGSize size = CGSizeMake(firstImg.size.width,firstImg.size.height);
    UIGraphicsBeginImageContext(size);
    
    CGPoint firstPoint = CGPointMake(0,0);
    [firstImg drawAtPoint:firstPoint];
    
    CGPoint secondPoint = point;
    [secondImg drawAtPoint: secondPoint];

    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

-(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleBlackTranslucent;
}
@end
