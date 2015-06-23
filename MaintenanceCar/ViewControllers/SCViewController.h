//
//  SCViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/17.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewControllerCategory.h"
#import "SCLoadingViewController.h"

@interface SCViewController : UIViewController <SCLoadingViewControllerDelegate>
{
    UIView *_loadingContainerView;
    SCLoadingViewController *_loadingViewController;
}

- (void)loadFinished;
- (void)loadError;
- (void)retryRequest;

@end
