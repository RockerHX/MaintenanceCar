//
//  SCCollectionsViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/5.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCListViewController.h"
#import "SCMerchantDetailViewController.h"

@protocol SCCollectionsViewControllerDelegate <NSObject>

@optional
- (void)shouldShowMenu;
- (void)shouldSupportPanGesture:(BOOL)support;

@end

@interface SCCollectionsViewController : SCListViewController <SCMerchantDetailViewControllerDelegate>

@property (nonatomic, weak) id  <SCCollectionsViewControllerDelegate>delegate;

- (IBAction)menuButtonPressed;

+ (UINavigationController *)navigationInstance;
+ (instancetype)instance;

@end
