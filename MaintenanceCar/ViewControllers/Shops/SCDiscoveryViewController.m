//
//  SCDiscoveryViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCDiscoveryViewController.h"
#import "SCSearchViewController.h"

@interface SCDiscoveryViewController () <SCSearchViewControllerDelegate>
@end

@implementation SCDiscoveryViewController
{
    BOOL _wantToSearch;
}

#pragma mark - View Controller Life Cycle
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
//    if (_wantToSearch)
//        self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Action Methods
- (IBAction)searchButtonItemPressed
{
    _wantToSearch = YES;
    SCSearchViewController *searchViewController = [SCSearchViewController instance];
    searchViewController.delegate = self;
    
//    CATransition *transition = [CATransition animation];
//    transition.type = kCATransitionFade;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.duration = 0.3f;
//    [self.navigationController pushViewController:searchViewController animated:NO];
//    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:searchViewController animated:YES];
}

#pragma mark - SCSearchViewControllerDelegate Methods
- (void)searchViewControllerReturnBack
{
    _wantToSearch = NO;
}

@end
