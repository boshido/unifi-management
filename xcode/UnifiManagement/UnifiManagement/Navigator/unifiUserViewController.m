//
//  unifiUserViewController.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 12/16/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import "unifiUserViewController.h"
#import "unifiUserResource.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface unifiUserViewController ()

@end

@implementation unifiUserViewController
@synthesize userOnline,userOffline,userSearch,userTable,searchBar,filterState,isSearched;

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
                   
    [unifiUserResource getUserList:^(NSJSONSerialization *responseJSON,NSString *reponseString){
        
        for(NSJSONSerialization *json in [responseJSON valueForKey:@"data"]){
            if([[json valueForKey:@"online"] intValue]>0){
                [ userOnline addObject:json];
            }
            else{
                [ userOffline addObject:json];
            }
        }
        NSLog(@"%@",userOnline);
        NSLog(@"%@",userOffline);

        [userTable reloadData];
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
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

//
//-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
//{
//    if(text.length == 0)
//    {
//        isSearched = NO;
//    }
//    else
//    {
//        isSearched = YES;
//        userSearch = [[NSMutableArray alloc] init];
//        __weak NSArray *tmp;
//        if(filterState==1) tmp = userOnline;
//        else tmp = userOffline;
//        
//        for (NSJSONSerialization* json in tmp)
//        {
//            NSRange nameRange = [json.name rangeOfString:text options:NSCaseInsensitiveSearch];
//            NSRange descriptionRange = [food.description rangeOfString:text options:NSCaseInsensitiveSearch];
//            if(nameRange.location != NSNotFound || descriptionRange.location != NSNotFound)
//            {
//                [filteredTableData addObject:food];
//            }
//        }
//    }
//    
//    [self.userTable reloadData];
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(filterState==1)return [userOnline count];
    else return [userOffline count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
//    [cell.imageView.layer setCornerRadius:22];
//    [cell.imageView.layer setMasksToBounds: YES];
//    // border
//    [cell.imageView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
//    [cell.imageView.layer setBorderWidth:0.3f];
    NSString *pictureUrl;
    
    if(filterState==1){
        cell.textLabel.text = [[userOnline objectAtIndex:indexPath.row] objectForKey:@"name"];
        pictureUrl = [[userOnline objectAtIndex:indexPath.row] objectForKey:@"picture"];
    }
    else{
        cell.textLabel.text = [[userOffline objectAtIndex:indexPath.row] objectForKey:@"name"];
        pictureUrl = [[userOnline objectAtIndex:indexPath.row] objectForKey:@"picture"];
    }
    
    
    [cell.imageView setImageWithURL:[NSURL URLWithString:pictureUrl]
        placeholderImage:[UIImage imageNamed:@"DateIcon.png"]
        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            
        }
     ];
    

    return cell;
}

- (void) dismissKeyboard
{
    // add self
    [self.searchBar resignFirstResponder];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleBlackTranslucent;
}
@end
