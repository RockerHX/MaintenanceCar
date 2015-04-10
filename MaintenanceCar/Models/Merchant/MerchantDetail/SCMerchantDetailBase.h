//
//  SCMerchantDetailBase.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCMerchantDetail;

@interface SCMerchantDetailBase : NSObject

@property (nonatomic, assign)        NSInteger  displayRow;
@property (nonatomic, copy, readonly) NSString *headerTitle;

- (instancetype)initWithMerchantDetail:(SCMerchantDetail *)detail;

@end
