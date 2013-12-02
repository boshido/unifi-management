//
//  unifiSettingViewController.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 12/2/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import "unifiSettingViewController.h"

@interface unifiSettingViewController ()

@end

@implementation unifiSettingViewController

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
   
    
    [NSThread detachNewThreadSelector:@selector(downloadAndLoadImage:) toTarget:self withObject:[unifiGlobalVariable sharedGlobalData].profilePicture];
    name.text = [NSString stringWithFormat:@"%@ %@",[unifiGlobalVariable sharedGlobalData].name,[unifiGlobalVariable sharedGlobalData].surname];
    surname.text = [unifiGlobalVariable sharedGlobalData].surname;
    email.text = [unifiGlobalVariable sharedGlobalData].email;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)signOut:(id)sender{
    ApiCallbackComplete callback = ^(NSJSONSerialization *response){
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *plistPath = [rootPath stringByAppendingPathComponent:@"refresh_token.plist"];
        
        NSError *error;
        if(![[NSFileManager defaultManager] removeItemAtPath:plistPath error:&error])
        {
            //TODO: Handle/Log error
        }
        [unifiGlobalVariable initialValue];
        
        [self dismissViewControllerAnimated:NO completion:nil];
        [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"unifiSplashViewController"] animated:NO completion:nil];
    };
    unifiApiConnector *object = [[unifiApiConnector alloc] initWithUrl:@"https://accounts.google.com/Logout"  andCallback:callback];
    [object loadGetData];
}

-(void)downloadAndLoadImage:(NSString *)url{
    NSURL *connector = [NSURL URLWithString:url];
    NSData *data = [[NSData alloc] initWithContentsOfURL:connector];
    
    // border radius
    [profilePicture.layer setCornerRadius:47.5f];
    [profilePicture.layer setMasksToBounds: YES];
    // border
    [profilePicture.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [profilePicture.layer setBorderWidth:0.3f];
    
    profilePicture.image = [[UIImage alloc] initWithData:data];
}
@end
