//
//  SCViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/17.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewController.h"

@implementation SCViewController

#pragma mark - Container Segue Methods
- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:NSStringFromClass([SCLoadingViewController class])])
    {
        _loadingViewController = segue.destinationViewController;
        _loadingViewController.delegate = self;
        _loadingContainerView.hidden = NO;
    }
}

#pragma mark - Private Methods
- (void)hideLoadingView
{
    [UIView transitionWithView:self.view duration:0.3f options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void)
     {
         [_loadingContainerView removeFromSuperview];
     } completion:^(BOOL finished) {
         [_loadingViewController removeFromParentViewController];
         _loadingContainerView = nil;
     }];
}

#pragma mark - Public Methods
- (void)loadFinished
{
    [self performSelector:@selector(hideLoadingView) withObject:nil afterDelay:0.5f];
}

- (void)loadError
{
    
}

#pragma mark - KMNetworkLoadingViewDelegate
- (void)retryRequest{}

@end
