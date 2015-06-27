//
//  SCFilter.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/26.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCFilter.h"

@implementation SCFilterCategoryItem

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"subItems": @"sub_items"};
}

@end

@implementation SCFilterCategory

- (BOOL)hasSubItems
{
    for (SCFilterCategoryItem *item in _items)
    {
        if (!item.subItems.count)
            return NO;
    }
    return YES;
}

@end

@implementation SCCarModelFilterCategory

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"myCars": @"my_cars",
          @"otherCars": @"other_cars"};
}

@end

@implementation SCFilter

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"serviceCategory": @"service",
              @"regionCategory": @"region",
            @"carModelCategory": @"car_model",
                @"sortCategory": @"sort"};
}

@end
