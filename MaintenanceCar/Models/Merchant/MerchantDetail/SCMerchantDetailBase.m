//
//  SCMerchantDetailBase.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMerchantDetailBase.h"
#import "SCMerchantDetail.h"

@implementation SCMerchantDetailBase

- (instancetype)initWithMerchantDetail:(SCMerchantDetail *)detail
{
    self = [super init];
    if (self)
    {
        _displayRow = 1;
    }
    return self;
}

@end
