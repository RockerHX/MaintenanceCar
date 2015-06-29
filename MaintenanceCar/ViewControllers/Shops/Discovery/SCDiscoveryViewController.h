//
//  SCDiscoveryViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCFilterViewController.h"

@class SCShopList;
@class SCFilterViewModel;
@class SCFilterView;

@interface SCDiscoveryViewController : SCFilterViewController <UITableViewDataSource, UITableViewDelegate>
{
    SCShopList        *_shopList;
    SCFilterViewModel *_filterViewModel;
}

@property (weak, nonatomic) IBOutlet SCFilterView *filterView;

+ (instancetype)instance;

@end
