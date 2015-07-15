//
//  SCDiscoveryViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "SCDiscoveryViewController.h"
#import "SCSearchViewController.h"

@implementation SCDiscoveryViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.filterView.state = SCFilterViewStateClose;
}

#pragma mark - Class Methods
+ (NSString *)navgationRestorationIdentifier
{
    return @"DiscoveryNavigationController";
}

#pragma mark - Config Methods
- (void)initConfig
{
    [super initConfig];
    
    @weakify(self)
    [RACObserve([SCUserInfo share], loginState) subscribeNext:^(NSNumber *loginState) {
        @strongify(self)
        [self.shopList reloadShops];
    }];
}

#pragma mark - Action Methods
- (IBAction)searchButtonItemPressed
{
    UINavigationController *searchNavigationViewController = [SCSearchViewController navigationInstance];
    searchNavigationViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:searchNavigationViewController animated:YES completion:nil];
}

@end
