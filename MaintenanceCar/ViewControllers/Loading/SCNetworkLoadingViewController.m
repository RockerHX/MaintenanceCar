//
//  SCNetworkLoadingViewController.m
//  BigCentral
//
//  Created by Kevin Mindeguia on 19/11/2013.
//  Copyright (c) 2013 iKode Ltd. All rights reserved.
//

#import "SCNetworkLoadingViewController.h"

@implementation SCNetworkLoadingViewController

#pragma mark -
#pragma mark View LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showLoadingView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.activityIndicatorView startAnimating];
}

- (void)showLoadingView
{
    self.errorView.hidden = YES;
    self.activityIndicatorView.color = [UIColor colorWithRed:232.0/255.0f green:35.0/255.0f blue:111.0/255.0f alpha:1.0];
}

- (void)showErrorView
{
    self.noContentView.hidden = YES;
    self.errorView.hidden = NO;
}

- (void)showNoContentView;
{
    self.noContentView.hidden = NO;
    self.errorView.hidden = YES;
}

#pragma mark -
#pragma mark Action Methods
- (IBAction)retryRequest
{
    [self showLoadingView];
    if ([self.delegate respondsToSelector:@selector(retryRequest)])
        [self.delegate retryRequest];
}
@end
