//
//  SCQuotedPriceGroup.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCQuotedPriceGroup.h"
#import "SCMerchantDetail.h"

@implementation SCQuotedPriceGroup

#pragma mark - Init Methods
- (instancetype)initWithMerchantDetail:(SCMerchantDetail *)detail {
    self = [super initWithMerchantDetail:detail];
    if (self) {
        self.productsCache = detail.normalProducts;
    }
    return self;
}

#pragma mark - Setter And Getter
- (NSString *)headerTitle {
    return @"业务及报价";
}

@end
