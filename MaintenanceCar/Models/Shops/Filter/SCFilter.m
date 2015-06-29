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

+ (NSDictionary *)objectClassInArray
{
    return @{@"subItems": @"SCFilterCategoryItem"};
}

@end

@implementation SCFilterCategory

+ (NSDictionary *)objectClassInArray
{
    return @{@"items": @"SCFilterCategoryItem"};
}

- (instancetype)setKeyValues:(id)keyValues context:(NSManagedObjectContext *)context error:(NSError *__autoreleasing *)error
{
    [super setKeyValues:keyValues context:context error:error];
    [self config];
    return self;
}

- (void)config
{
    BOOL has = NO;
    for (SCFilterCategoryItem *item in _items)
    {
        if (item.subItems.count)
            has = YES;
    }
    _hasSubItems = has;
    NSInteger max = 0;
    for (SCFilterCategoryItem *item in _items)
    {
        NSInteger count = item.subItems.count;
        max = (count > max) ? count : max;
    }
    NSInteger count = _items.count;
    _maxCount = (count > max) ? count : max;
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
