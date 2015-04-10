//
//  SCMerchantSummary.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMerchantDetailBase.h"

@class SCMerchantDetail;

@interface SCMerchantSummary : SCMerchantDetailBase

@property (nonatomic, copy, readonly)   NSString *name;
@property (nonatomic, copy, readonly)   NSString *majors;
@property (nonatomic, copy, readonly)   NSString *distance;
@property (nonatomic, copy, readonly)   NSString *star;

@property (nonatomic, strong, readonly)  NSArray *flags;
@property (nonatomic, assign, readonly)      BOOL unReserve;

@end