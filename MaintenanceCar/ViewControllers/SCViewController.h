//
//  SCViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/17.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewControllerCategory.h"
#import "SCLoadingViewController.h"
#import "SCServerResponse.h"

@interface SCViewController : UIViewController <SCLoadingViewControllerDelegate>
{
    SCLoadingViewController *_loadingViewController;
}

@property (weak, nonatomic) IBOutlet UIView *loadingContainerView;

+ (instancetype)instance;

- (void)showLoading;
- (void)loadFinished;
- (void)showNoContent;
- (void)loadError;

- (void)retryRequest;
- (void)hanleServerResponse:(SCServerResponse *)response;

@end
