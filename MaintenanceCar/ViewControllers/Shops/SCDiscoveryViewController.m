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

#pragma mark - Class Methods
+ (NSString *)navgationRestorationIdentifier
{
    return @"DiscoveryNavigationController";
}

#pragma mark - Action Methods
- (IBAction)searchButtonItemPressed
{
    UINavigationController *searchNavigationViewController = [SCSearchViewController navigationInstance];
    searchNavigationViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:searchNavigationViewController animated:YES completion:nil];
}

@end
