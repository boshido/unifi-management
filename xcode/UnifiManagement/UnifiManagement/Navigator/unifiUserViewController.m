//
//  unifiUserViewController.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 12/16/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import "unifiUserViewController.h"
#import "unifiUserResource.h"
#import "unifiProfileViewController.h"
#import "unifiTableViewCell.h"
#import "DejalActivityView.h"

@interface unifiUserViewController ()

@end

@implementation unifiUserViewController
@synthesize userOnline,userOffline,userSearch,userTable,searchBar,filterView,filterState,isSearched;

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

    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, searchBar.frame.size.height, searchBar.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:0.867 green:0.867 blue:0.867 alpha:1.0].CGColor;
    [searchBar.layer addSublayer:bottomBorder ];
    
    [searchBar setBackgroundImage:[UIImage imageNamed:@"BlackBG2.png"]];
    [searchBar setTranslucent:YES];
    
    userTable.delegate = self;
    userTable.dataSource = self;
    searchBar.delegate = self;
    filterState=1;
    isSearched=NO;
    userOnline = [[NSMutableArray alloc] init];
    userOffline = [[NSMutableArray alloc] init];
    [DejalBezelActivityView currentActivityView].showNetworkActivityIndicator = YES;
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading."];
    
    [unifiUserResource getUserList:^(NSJSONSerialization *responseJSON,NSString *reponseString){
        
        __block NSInteger count = 0;
        __block NSData *data;
        __block UIImage *image;
        for(NSMutableDictionary *json in [responseJSON valueForKey:@"data"]){

            dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(concurrentQueue, ^{
                
                if([json valueForKey:@"picture"] == NULL || [json valueForKey:@"picture"] == [NSNull null]){
                    image = [UIImage imageNamed:@"profile.jpg"];
                }
                else{
                    
                    data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[json valueForKey:@"picture"]]];
                    image = [[UIImage alloc]initWithData:data ];
                }
                NSDictionary *dictionary = @{ @"json"     : json,
                                              @"image" : image,
                                            };
            
                if([[json valueForKey:@"online"] intValue]>0){
                    [userOnline addObject:dictionary];
                }
                else{
                    [userOffline addObject:dictionary];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    count++;
                    if(count >= [[responseJSON valueForKey:@"data"] count]){
                        [userTable reloadData];
                        [DejalBezelActivityView removeViewAnimated:YES];
                    }
                });
            });
        }

        //[userTable reloadData];
    }];
    
    UITapGestureRecognizer *filterTap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(filterTap)];
    
    [filterView addGestureRecognizer:filterTap];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backToParent:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)backToHome:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)bar {
    dismissKeybaordTap = [[UITapGestureRecognizer alloc]
                                                  initWithTarget:self
                                                  action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:dismissKeybaordTap];
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
   
    if(text.length == 0)
    {
        isSearched = NO;
    }
    else
    {
        isSearched = YES;
        userSearch = [[NSMutableArray alloc] init];
        __weak NSArray *tmp;
        if(filterState==1) tmp = userOnline;
        else tmp = userOffline;
        
        for (NSJSONSerialization* json in tmp)
        {
            NSRange nameRange = [[[json valueForKey:@"json"] valueForKey:@"name"] rangeOfString:text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound)
            {
                [userSearch addObject:json];
            }
        }
    }
    
    [self.userTable reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isSearched)return [userSearch count];
    else if(filterState==1)return [userOnline count];
    else return [userOffline count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    unifiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[unifiTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell.imageView.layer setCornerRadius:17.5f];
    [cell.imageView.layer setMasksToBounds: YES];
    // border
    [cell.imageView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [cell.imageView.layer setBorderWidth:0.3f];
    
    if(isSearched){
        cell.textLabel.text = [[[userSearch objectAtIndex:indexPath.row] objectForKey:@"json"] objectForKey:@"name"];
        cell.imageView.image = [[userSearch objectAtIndex:indexPath.row] objectForKey:@"image"];
    }
    else if(filterState==1){
        cell.textLabel.text = [[[userOnline objectAtIndex:indexPath.row] objectForKey:@"json"] objectForKey:@"name"];
        cell.imageView.image = [[userOnline objectAtIndex:indexPath.row] objectForKey:@"image"];
    }
    else{
        cell.textLabel.text = [[[userOffline objectAtIndex:indexPath.row] objectForKey:@"json"] objectForKey:@"name"];
        cell.imageView.image = [[userOffline objectAtIndex:indexPath.row] objectForKey:@"image"];
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    unifiProfileViewController * profile = [self.storyboard instantiateViewControllerWithIdentifier:@"unifiProfileViewController"];

    if(isSearched){
        [profile setUserData:[[userSearch objectAtIndex:indexPath.row] objectForKey:@"json"]];
    }
    else if(filterState==1){
        [profile setUserData:[[userOnline objectAtIndex:indexPath.row] objectForKey:@"json"]];
    }
    else{
        [profile setUserData:[[userOffline objectAtIndex:indexPath.row] objectForKey:@"json"]];
    }
    
    [[self navigationController] pushViewController:profile animated:YES];
}

- (void) dismissKeyboard
{
    [self.view removeGestureRecognizer:dismissKeybaordTap];
    // add self
    [self.searchBar resignFirstResponder];
}
-(void) filterTap
{
    UILabel *label = (UILabel *)[self.view viewWithTag:100];
    UIImageView *image = (UIImageView *)[self.view viewWithTag:101];
    
    if(filterState==1)
    {
        [label setText:@"Offline"];
        [image setHighlighted:YES];
        filterState=2;
    }
    else {
        [label setText:@"Online"];
        [image setHighlighted:NO];
        filterState=1;
    }
        
    [self.userTable reloadData];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleBlackTranslucent;
}
@end
