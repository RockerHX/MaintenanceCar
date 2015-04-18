//
//  SCMerchantProductGroup.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMerchantProductGroup.h"
#import "SCMerchantDetail.h"

@implementation SCMerchantProductGroup

#pragma mark - Init Methods
- (instancetype)initWithMerchantDetail:(SCMerchantDetail *)detail
{
    self = [super initWithMerchantDetail:detail];
    if (self)
    {
        self.productsCache = detail.products;
    }
    return self;
}

#pragma mark - Setter And Gette
-(NSString *)headerTitle
{
    return @"团购";
}

@end
