//
//  unifiMapViewController.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 2/8/2557 BE.
//  Copyright (c) 2557 KMUTNB. All rights reserved.
//

#import "unifiMapViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "unifiSystemResource.h"
#import "unifiTableViewCell.h"

@interface unifiMapViewController ()

@end

@implementation unifiMapViewController
@synthesize scrollView,mapTable,map,mapList;
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
//    scrollView.minimumZoomScale=0.5;
//    scrollView.maximumZoomScale=6.0;
//    //scrollView.contentSize=CGSizeMake(1280, 960);
//    scrollView.delegate = self;
//	// Do any additional setup after loading the view.
//    map = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
//    [map setImageWithURL:[NSURL URLWithString:@"http://192.168.0.2/unifi/map?id=529cbdce38410430ff57db1a"]
//                   placeholderImage:[UIImage imageNamed:@"profile.jpg"] options:SDWebImageRefreshCached];
//    
//    [scrollView addSubview:map];
    mapTable.delegate = self;
    mapTable.dataSource = self;
    
    [unifiSystemResource
        getMapList:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
            NSLog(@"%@",responseJSON);
            mapList = [responseJSON valueForKey:@"data"];
            [mapTable reloadData];
        }
        withHandleError:^(NSError *error) {
        
        }
     ];
}
//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
//{
//    NSLog(@"Zooming");
//    return map;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mapList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    unifiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[unifiTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    [cell setCellStyle:TextWithTreeDetailStyle];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    NSJSONSerialization *json = [mapList objectAtIndex:indexPath.row];
    cell.textLabel.text = [json valueForKey:@"name"];
    
    NSLog(@"%@",json );
    NSLog(@"%@",[NSString stringWithFormat:@"http://%@/unifi/map?id=%@",ApiServerAddress,[json valueForKey:@"file_id"]]);
    if([json valueForKey:@"file_id"] != nil)
        
        [cell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/unifi/map?id=%@",ApiServerAddress,[json valueForKey:@"file_id"]]]
                       placeholderImage:[UIImage imageNamed:@"profile.jpg"] options:SDWebImageRefreshCached];
    else
        cell.imageView.image = [UIImage imageNamed:@"profile.jpg"];
    cell.detailTextLabel.text = @"Device : 400";
    cell.secondDetailTextLabel.text = @"AP : 8/8";
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    unifiUserProfileViewController * profile = [self.storyboard instantiateViewControllerWithIdentifier:@"unifiUserProfileViewController"];
//    
//    if(isSearched){
//        [profile setGoogleId:[[userSearch objectAtIndex:indexPath.row] valueForKey:@"google_id"]];
//    }
//    else if(filterState==1){
//        [profile setGoogleId:[[userOnline objectAtIndex:indexPath.row] valueForKey:@"google_id"]];
//    }
//    else{
//        [profile setGoogleId:[[userOffline objectAtIndex:indexPath.row] valueForKey:@"google_id"]];
//    }
//    
//    [[self navigationController] pushViewController:profile animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleBlackTranslucent;
}
@end
