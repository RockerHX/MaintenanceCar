//
//  SCGroupBase.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMerchantDetailBase.h"

@interface SCGroupBase : SCMerchantDetailBase

@property (nonatomic, assign)                BOOL isOpen;
@property (nonatomic, assign, readonly)      BOOL canOpen;
@property (nonatomic, assign, readonly) NSInteger totalProductCount;

@property (nonatomic, strong, readonly)  NSArray *products;
@property (nonatomic, strong)            NSArray *productsCache;

@end
