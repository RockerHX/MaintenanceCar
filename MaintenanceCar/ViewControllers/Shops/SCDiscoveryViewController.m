//
//  SCDiscoveryViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCDiscoveryViewController.h"
#import "SCSearchViewController.h"

@implementation SCDiscoveryViewController

#pragma mark - Action Methods
- (IBAction)searchButtonItemPressed
{
    SCSearchViewController *searchViewController = [SCSearchViewController instance];
    searchViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:searchViewController animated:YES completion:nil];
}

@end
