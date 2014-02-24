//
//  unifiRatioViewController.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 2/19/2557 BE.
//  Copyright (c) 2557 KMUTNB. All rights reserved.
//

#import "unifiRatioViewController.h"
#import "unifiSystemResource.h"
#import "DejalActivityView.h"
#import "unifiFailureViewController.h"
@interface unifiRatioViewController ()

@end

@implementation unifiRatioViewController{
    NSInteger pageNumber;
    NSJSONSerialization *ratioData;
    ApiErrorCallback handleError;
}
@synthesize ratioChart,header,alertLabel,leftButton,rightButton;
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
    
    __weak typeof(self) weakSelf=self;
    handleError= ^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:YES];
        unifiFailureViewController *failureController = [[weakSelf storyboard] instantiateViewControllerWithIdentifier:@"unifiFailureViewController"];
        [[weakSelf navigationController] presentViewController:failureController animated:YES completion:nil];
    };
	// Do any additional setup after loading the view.
    
   }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
    
    pageNumber=2;
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"ratio" ofType:@"html"]]];
    ratioChart.delegate = self;
    ratioChart.scrollView.scrollEnabled = NO;
    ratioChart.scrollView.bounces = NO;
    [ratioChart loadRequest:urlRequest];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [ratioChart addGestureRecognizer:swipeLeft];
    swipeLeft.delegate = self;
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [ratioChart addGestureRecognizer:swipeRight];
    swipeRight.delegate = self;

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self loadRatioData];
}

-(void)loadRatioData{
    [DejalBezelActivityView currentActivityView].showNetworkActivityIndicator = YES;
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading."];
    
    [unifiSystemResource
        getCurrentUsage:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
             if([[responseJSON valueForKey:@"code"] intValue]== 200){
                 ratioData = [responseJSON valueForKey:@"data"];
                 
                 dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                     NSMutableArray *dataSource = [[NSMutableArray alloc] init];
                     double max=0;
                     NSString *unit = @"";
                     NSInteger count=0;
                     
                     if(pageNumber == 1){
                         
                         for(NSJSONSerialization *json in [ratioData valueForKey:@"wlan"]){
                             if(count >11)break;
                             [dataSource addObject: @{
                                                      @"name":[json valueForKey:@"name"],
                                                      @"val":[ NSNumber numberWithLongLong:[[json valueForKey:@"value"] longLongValue]]
                                                      }];
                             
                              count++;
                              if(max < [[json valueForKey:@"value"] longLongValue])max = [[json valueForKey:@"value"] doubleValue];
                         }
                        
                     }
                     else if(pageNumber == 2){
                         for(NSJSONSerialization *json in [ratioData valueForKey:@"traffic"]){
                             if(count >11)break;
                             [dataSource addObject: @{
                                                      @"name":[json valueForKey:@"name"],
                                                      @"val":[ NSNumber numberWithDouble:[[json valueForKey:@"value"] doubleValue]]
                                                      }];
                             if(max < [[json valueForKey:@"value"] longLongValue])max = [[json valueForKey:@"value"] doubleValue];
                             count++;
                         }
                         long divide=1;
                         if((NSInteger)(max / 1073741824) != 0){
                             divide = 1073741824;
                             unit = @"GB";
                         }
                         else if((NSInteger)(max / 1048576) != 0){
                             divide = 1048576;
                             unit = @"MB";
                         }
                         else if((NSInteger)(max / 1024) != 0){
                             divide = 1024;
                             unit = @"KB";
                         }
                         else{
                             unit = @"B";
                         }
                         
                         for(NSInteger i=0;i<[dataSource count];i++){
                             NSJSONSerialization *json= [dataSource objectAtIndex:i];
                             [dataSource replaceObjectAtIndex:i withObject:@{
                                                                             @"name":[json valueForKey:@"name"],
                                                                             @"val":[ NSNumber numberWithDouble:[[json valueForKey:@"val"] doubleValue]/divide]
                                                                             }];
                         }
                     }
                     else{
                         for(NSJSONSerialization *json in [ratioData valueForKey:@"count"]){
                             if(count >11)break;
                             [dataSource addObject: @{
                                                      @"name":[json valueForKey:@"name"],
                                                      @"val":[ NSNumber numberWithLongLong:[[json valueForKey:@"value"] longLongValue]]
                                                      }];
                             count++;
                             if(max < [[json valueForKey:@"value"] longLongValue])max = [[json valueForKey:@"value"] doubleValue];
                         }
                     }
                     
                    
                         
                     NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataSource
                                                                        options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                                          error:nil];
                     NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                     
                     
                     dispatch_async(dispatch_get_main_queue(), ^(void){
                         ratioChart.alpha =1;
                         if(pageNumber == 1){
                            header.text = @"Wlan Device Count";
                             leftButton.alpha=0;
                         }
                         else if(pageNumber == 2){
                            header.text = @"AP Traffic Usage";
                            leftButton.alpha = 1;
                            rightButton.alpha = 1;
                         }
                         else{
                            header.text = @"AP Device Count";
                            rightButton.alpha=0;
                         }
                         
                         if(max>0) alertLabel.alpha = 0.0f;
                         else alertLabel.alpha = 1.0f;
                         
                         if (jsonData) {
                             [ ratioChart stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setValue(%@,\"%@\")", jsonString,unit]];
                         }
                         [DejalBezelActivityView removeViewAnimated:YES];
                     });
                 });
             }
         }
         withHandleError:handleError
     ];
}

-(IBAction)backToParent:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

// -------------------------- Event ---------------------------------

-(IBAction)goLeft:(id)sender{
    if(pageNumber > 1){
        pageNumber--;
        [self loadRatioData];
        
    }
    else{
        
    }
    
}
-(IBAction)goRight:(id)sender{
    if(pageNumber < 3){
        pageNumber++;
        [self loadRatioData];
    }
    else{
        
    }
}

-(void) swipeLeft:(UISwipeGestureRecognizer *) recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        if(pageNumber < 3){
            pageNumber++;
            [self loadRatioData];
        }
        else{
            
        }
    }
}

-(void) swipeRight:(UISwipeGestureRecognizer *) recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        if(pageNumber > 1){
            pageNumber--;
            [self loadRatioData];
        }
        else{
          
        }
        

    }
}


// ----------------------------------   Other       ------------------------------------

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleBlackTranslucent;
}
@end
