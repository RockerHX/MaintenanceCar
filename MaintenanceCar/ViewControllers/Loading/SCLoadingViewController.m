//
//  SCLoadingViewController.m
//  BigCentral
//
//  Created by Kevin Mindeguia on 19/11/2013.
//  Copyright (c) 2013 iKode Ltd. All rights reserved.
//

#import "SCLoadingViewController.h"

@implementation SCLoadingViewController

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
    [_activityIndicatorView startAnimating];
}

- (void)showLoadingView
{
    _errorView.hidden = YES;
    _activityIndicatorView.color = [UIColor colorWithRed:232.0f/255.0f green:35.0f/255.0f blue:111.0f/255.0f alpha:1.0f];
}

- (void)showErrorView
{
    _noContentView.hidden = YES;
    _errorView.hidden = NO;
}

- (void)showNoContentView;
{
    _noContentView.hidden = NO;
    _errorView.hidden = YES;
}

#pragma mark -
#pragma mark Action Methods
- (IBAction)retryButtonPressed
{
    [self showLoadingView];
    if ([_delegate respondsToSelector:@selector(retryRequest)])
        [_delegate retryRequest];
}
@end
