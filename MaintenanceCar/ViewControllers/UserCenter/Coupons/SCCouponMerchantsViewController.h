//
//  SCCouponMerchantsViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/24.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewControllerCategory.h"

@interface SCCouponMerchantsViewController : UITableViewController
{
    NSInteger       _offset;
    NSString       *_distanceCondition;
    NSMutableArray *_merchants;
}

@property (nonatomic, copy) NSString *couponCode;

+ (instancetype)instance;

@end
