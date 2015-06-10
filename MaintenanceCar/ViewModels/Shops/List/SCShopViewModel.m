//
//  SCShopViewModel.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCShopViewModel.h"

@implementation SCShopViewModel

+ (instancetype)initWithShop:(SCShop *)shop
{
    return [self objectWithKeyValues:shop.keyValues];
}

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"canPay": @"can_pay",
                 @"ID": @"company_id",
           @"products": @"product"};
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"products": @"SCShopProduct"};
}

@end
