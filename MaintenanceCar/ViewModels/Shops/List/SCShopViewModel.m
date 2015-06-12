//
//  SCShopViewModel.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCShopViewModel.h"
#import "SCLocationManager.h"

static int popMax = 2;

@implementation SCShopViewModel
{
    NSArray *_dataSource;
}

#pragma mark - Init Methods
- (instancetype)initWithShop:(SCShop *)shop
{
    self = [super init];
    if (self)
    {
        _shop = shop;
        [self propertyConfig];
        [self hanleProducts];
    }
    return self;
}

#pragma mark - Private Methods
- (void)propertyConfig
{
    _star = [_shop.star stringByAppendingString:@"分"];
    _distance = [[SCLocationManager share] distanceWithLatitude:_shop.latitude longitude:_shop.longtitude];
    _repairTypeImageName = _shop.repair.type ? @"MerchantZhuanTagIcon" : @"MerchantZongTagIcon";
    [_shop.repair.haveNot enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        _repairPrompt = [_repairPrompt stringByAppendingString:stop ? [NSString stringWithFormat:@"%@、", obj] : obj];
    }];
}

- (void)hanleProducts
{
    __weak typeof(self)weakSelf = self;
    NSInteger productCount = _shop.products.count;
    NSMutableArray *dataSource = @[].mutableCopy;
    [dataSource addObject:weakSelf];
    if (productCount > popMax)
    {
        _canPop = YES;
        [dataSource addObject:_shop.products[0]];
        [dataSource addObject:_shop.products[1]];
        [dataSource addObject:[NSString stringWithFormat:@"查看全部%zd款", productCount]];
    }
    else
    {
        [_shop.products enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [dataSource addObject:_shop.products[idx]];
        }];
    }
    _dataSource = [NSArray arrayWithArray:dataSource];
}

#pragma mark - Setter And Getter Methods
- (NSArray *)cellDisplayData
{
    if (_productsPop)
    {
        // TODO
        return nil;
    }
    else
        return _dataSource;
}

@end
