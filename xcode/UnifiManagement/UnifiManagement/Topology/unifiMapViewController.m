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
#import "unifiMapProfileViewController.h"

@interface unifiMapViewController ()

@end

@implementation unifiMapViewController
@synthesize mapTable,mapList;
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

    mapTable.delegate = self;
    mapTable.dataSource = self;
    
}
-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"haha");
    [unifiSystemResource
        getMapList:^(NSJSONSerialization *responseJSON, NSString *responseNSString) {
            mapList = [responseJSON valueForKey:@"data"];
            [mapTable reloadData];
        }
        withHandleError:^(NSError *error) {
        
        }
    ];
}


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
    
    if([json valueForKey:@"file_id"] != nil)
        
        [cell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/unifi/map?id=%@",ApiServerAddress,[json valueForKey:@"file_id"]]]
                       placeholderImage:[UIImage imageNamed:@"profile.jpg"] options:SDWebImageRefreshCached];
    else
        cell.imageView.image = [UIImage imageNamed:@"profile.jpg"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Devices : %i",[[json valueForKey:@"device_count"] intValue]];
    cell.secondDetailTextLabel.text = [NSString stringWithFormat:@"AP : %i/%i",[[[json valueForKey:@"ap"] valueForKey:@"connected"] intValue],[[[json valueForKey:@"ap"] valueForKey:@"connected"] intValue]+[[[json valueForKey:@"ap"] valueForKey:@"disconnected"] intValue]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    unifiMapProfileViewController * profile = [self.storyboard instantiateViewControllerWithIdentifier:@"unifiMapProfileViewController"];
    [profile setMapId:[[mapList objectAtIndex:indexPath.row] valueForKey:@"_id"]];
    [profile setMapPictureId:[[mapList objectAtIndex:indexPath.row] valueForKey:@"file_id"]];
    [profile setMapName:[[mapList objectAtIndex:indexPath.row] valueForKey:@"name"]];
    
    
    [[self navigationController] pushViewController:profile animated:YES];
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
