//
//  SCCollectionsViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/5.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCListViewController.h"
#import "SCMerchantDetailViewController.h"

@interface SCCollectionsViewController : SCListViewController <SCMerchantDetailViewControllerDelegate>

+ (UINavigationController *)navigationInstance;
+ (instancetype)instance;

@end
