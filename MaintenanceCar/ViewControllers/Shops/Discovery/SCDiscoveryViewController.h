//
//  SCDiscoveryViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewControllerCategory.h"

@class SCShopList;

@interface SCDiscoveryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    SCShopList *_shopList;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

+ (instancetype)instance;

@end
