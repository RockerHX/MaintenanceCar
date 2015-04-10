//
//  SCMerchantSummary.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMerchantSummary.h"
#import "SCMerchantDetail.h"
#import "SCAllDictionary.h"

@implementation SCMerchantSummary

#pragma mark - Init Methods
- (instancetype)initWithMerchantDetail:(SCMerchantDetail *)detail
{
    self = [super initWithMerchantDetail:detail];
    if (self)
    {
        _name       = detail.name;
        _majors     = detail.majors;
        _distance   = detail.distance;
        _star       = [@([detail.star integerValue]/2) stringValue];
        _flags      = [detail.flags componentsSeparatedByString:@","];
        _unReserve  = ![SCAllDictionary share].serviceItems.count;
    }
    return self;
}

@end
