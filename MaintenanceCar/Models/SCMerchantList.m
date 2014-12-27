//
//  SCMerchantList.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/27.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCMerchantList.h"

static SCMerchantList *merchantList = nil;

@implementation SCMerchantList

#pragma mark - Init Methods
#pragma mark -
+ (instancetype)shareList
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        merchantList = [[SCMerchantList alloc] init];
    });
    return merchantList;
}

@end
