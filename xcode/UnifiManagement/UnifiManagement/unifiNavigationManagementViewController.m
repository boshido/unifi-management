//
//  unifiNavigationManagementViewController.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 12/10/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import "unifiNavigationManagementViewController.h"

@interface unifiNavigationManagementViewController ()

@end

@implementation unifiNavigationManagementViewController

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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)settingView:(unifiSettingViewController *)viewController
        didSignoutSign:(BOOL)sign{
    [self popToRootViewControllerAnimated:NO];
}


@end
