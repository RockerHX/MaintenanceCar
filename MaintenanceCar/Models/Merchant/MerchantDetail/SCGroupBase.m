//
//  SCGroupBase.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCGroupBase.h"

#define MaxProductShowCount     2

@implementation SCGroupBase

#pragma mark - Setter And Getter
- (NSInteger)displayRow
{
    if (self.canOpen)
        return _isOpen ? (self.products.count + 1) : (MaxProductShowCount + 1);
    else
        return _productsCache.count;
}

- (BOOL)canOpen
{
    return (_productsCache.count > MaxProductShowCount);
}

- (NSInteger)totalProductCount
{
    return _productsCache.count;
}

- (NSArray *)products
{
    if (self.canOpen)
        return _isOpen ? _productsCache : [_productsCache objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:(NSRange){0, MaxProductShowCount}]];
    else
        return _productsCache;
}

@end
