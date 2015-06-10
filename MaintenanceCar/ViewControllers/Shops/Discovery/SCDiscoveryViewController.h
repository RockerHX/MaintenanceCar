//
//  SCDiscoveryViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewControllerCategory.h"

@interface SCDiscoveryViewController : UIViewController <UITableViewDataSource, UITabBarDelegate>
{
    NSMutableArray *_merchants;
}

+ (instancetype)instance;

@end
