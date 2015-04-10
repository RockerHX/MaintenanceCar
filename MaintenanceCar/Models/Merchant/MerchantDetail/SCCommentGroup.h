//
//  SCCommentGroup.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCMerchantDetailBase.h"

@class SCMerchantDetail;

@interface SCCommentMore : SCMerchantDetailBase

@property (nonatomic, assign, readonly) NSInteger commentsCount;

@end


@interface SCCommentGroup : SCMerchantDetailBase

@property (nonatomic, strong, readonly) NSArray *comments;

@end
