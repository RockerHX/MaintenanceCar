//
//  SCMerchantGroup.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMerchantDetailBase.h"

@class SCMerchantDetail;

@interface SCMerchantGroup : SCMerchantDetailBase

@property (nonatomic, assign)                BOOL isOpen;
@property (nonatomic, assign, readonly)      BOOL canOpen;
@property (nonatomic, assign, readonly) NSInteger totalProductCount;

@property (nonatomic, strong, readonly)  NSArray *products;

@end
