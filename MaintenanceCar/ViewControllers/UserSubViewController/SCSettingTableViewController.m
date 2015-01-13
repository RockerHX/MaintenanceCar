//
//  SCSettingTableViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/13.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCSettingTableViewController.h"
#import "UMFeedback.h"

@interface SCSettingTableViewController ()

@end

@implementation SCSettingTableViewController

#pragma mark - View Controller Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && indexPath.row == 0)
    {
//        [self.navigationController pushViewController:[UMFeedback feedbackViewController] animated:YES];
        [self presentViewController:[UMFeedback feedbackModalViewController] animated:YES completion:nil];
    }
}

@end
