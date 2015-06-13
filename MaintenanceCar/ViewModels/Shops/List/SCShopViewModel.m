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
        [self initConfig];
        [self propertyConfig];
        [self hanleProducts];
    }
    return self;
}

#pragma mark - Config Methods
- (void)initConfig
{
}

- (void)propertyConfig
{
    _star = [_shop.star stringByAppendingString:@"分"];
    _distance = [[SCLocationManager share] distanceWithLatitude:_shop.latitude longitude:_shop.longtitude];
    _repairTypeImageName = _shop.repair.type ? @"MerchantZhuanTagIcon" : @"MerchantZongTagIcon";
    [self handleRepairPrompt];
    [self hanldeFlags];
}

#pragma mark - Private Methods
- (void)handleRepairPrompt
{
    _repairPrompt = @"";
    NSArray *brands = _shop.repair.haveNot;
    NSInteger count = brands.count;
    for (NSUInteger index = 0; index < count; index++)
        _repairPrompt = [_repairPrompt stringByAppendingString:((index == (count - 1)) ? brands[index] : [NSString stringWithFormat:@"%@、", brands[index]])];
}

- (void)hanldeFlags
{
    NSMutableArray *flags = @[].mutableCopy;
    @try {
        [_shop.flags enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isEqualToString:@"洗"])
                [flags addObject:@"MerchantTagWashIcon"];
            else if ([obj isEqualToString:@"养"])
                [flags addObject:@"MerchantTagMaintenanceIcon"];
            else if ([obj isEqualToString:@"修"])
                [flags addObject:@"MerchantTagRepairIcon"];
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"SCShopViewModel Hanlde Flags Error:%@", exception.reason);
    }
    @finally {
        _flags = [NSArray arrayWithArray:flags];
    }
}

- (void)hanleProducts
{
    __weak typeof(self)weakSelf = self;
    NSInteger productCount     = _shop.products.count;
    NSArray *products          = _shop.products;
    NSMutableArray *dataSource = @[].mutableCopy;
    [dataSource addObject:weakSelf];
    if (productCount > popMax)
    {
        _canOpen = YES;
        [dataSource addObject:products[0]];
        [dataSource addObject:products[1]];
        [dataSource addObject:[NSString stringWithFormat:@"查看全部%zd款", productCount]];
    }
    else
    {
        [products enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [dataSource addObject:products[idx]];
        }];
    }
    _dataSource = [NSArray arrayWithArray:dataSource];
}

#pragma mark - Public Methods
- (void)operateProductsMenu:(void(^)(BOOL shouldReload))block
{
    if (_canOpen)
    {
        NSInteger productCount     = _shop.products.count;
        NSArray *products          = _shop.products;
        NSMutableArray *dataSource = [NSMutableArray arrayWithArray:_dataSource];
        [dataSource removeLastObject];
        if (_productsOpen)
        {
            for (NSInteger index = productCount; index > popMax; --index)
                [dataSource removeObjectAtIndex:index];
            [dataSource addObject:[NSString stringWithFormat:@"查看全部%zd款", productCount]];
        }
        else
        {
            for (NSInteger index = popMax; index < productCount; index++)
                [dataSource addObject:products[index]];
            [dataSource addObject:@"收起"];
        }
        _productsOpen = !_productsOpen;
        _dataSource = [NSArray arrayWithArray:dataSource];
        
        block(YES);
    }
    else
        block(NO);
}

@end
