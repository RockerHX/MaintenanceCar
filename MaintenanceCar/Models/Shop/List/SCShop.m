//
//  SCShop.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCShop.h"

@implementation SCShopCharacteristic

@end

@implementation SCShopRepair

#pragma Class Methods
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"haveNot": @"have_not"};
}

@end

@implementation SCShopProduct

#pragma Class Methods
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"ID": @"product_id",
        @"isGroup": @"is_group",
  @"discountPrice": @"final_price"};
}

@end

@implementation SCShop

#pragma Class Methods
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"canPay": @"can_pay",
                 @"ID": @"company_id",
           @"products": @"product"};
}

+ (NSDictionary *)objectClassInArray {
    return @{@"products": @"SCShopProduct"};
}

@end
