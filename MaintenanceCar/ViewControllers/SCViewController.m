//
//  SCViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/17.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewController.h"

@implementation SCViewController

#pragma mark - Init Methods
+ (instancetype)instance
{
    return nil;
}

#pragma mark - Container Segue Methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
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
    [UIView transitionWithView:self.view duration:0.3f options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void){
        _loadingContainerView.hidden = YES;
    } completion:^(BOOL finished) {
        [_loadingViewController hiddenLoadingView];
    }];
}

- (void)showErrorView
{
    [self hideLoadingView];
    [_loadingViewController showErrorView];
}

#pragma mark - Public Methods
- (void)showLoading
{
    [UIView transitionWithView:self.view duration:0.2f options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void){
        _loadingContainerView.hidden = NO;
    } completion:^(BOOL finished) {
        [_loadingViewController showLoadingView];
    }];
}

- (void)loadFinished
{
    [self performSelector:@selector(hideLoadingView) withObject:nil afterDelay:0.5f];
}

- (void)showNoContent
{
    [UIView transitionWithView:self.view duration:0.2f options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void){
        _loadingContainerView.hidden = NO;
    } completion:^(BOOL finished) {
        [_loadingViewController showNoContentView];
    }];
}

- (void)loadError
{
    [self performSelector:@selector(showErrorView) withObject:nil afterDelay:0.5f];
}

- (void)hanleServerResponse:(SCServerResponse *)response
{
    switch (response.statusCode)
    {
        case SCAPIRequestErrorCodeNoError:
            [self loadFinished];
            break;
        case SCAPIRequestStatusCodeTokenError:
            [self showShoulReLoginAlert];
            break;
        case SCAPIRequestErrorCodeListNotFoundMore:
            [self loadFinished];
            break;
        default:
            [self loadError];
            break;
    }
    if (response.prompt.length)
        [self showHUDAlertToViewController:self text:response.prompt];
    if (response.locationPrompt.length)
        [self showHUDAlertToViewController:self text:response.locationPrompt];
}

#pragma mark - KMNetworkLoadingViewDelegate
- (void)retryRequest{}

@end
