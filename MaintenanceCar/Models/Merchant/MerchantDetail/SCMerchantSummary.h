//
//  SCMerchantSummary.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMerchantDetailBase.h"

@class SCMerchantDetail;

@interface SCMerchantFlag : NSObject

@property (nonatomic, copy)           NSString *flag;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *prompt;
@property (nonatomic, copy, readonly) NSString *content;
@property (nonatomic, copy, readonly) NSString *imageName;
@property (nonatomic, copy, readonly) NSString *colorHex;

- (instancetype)initWithMerchantDetail:(SCMerchantDetail *)detail flag:(NSString *)flag;

@end


@interface SCMerchantSummary : SCMerchantDetailBase

@property (nonatomic, copy, readonly)  NSString *name;
@property (nonatomic, copy, readonly)  NSString *distance;
@property (nonatomic, copy, readonly)  NSString *star;

@property (nonatomic, strong, readonly) NSArray *flags;
@property (nonatomic, assign, readonly)     BOOL unReserve;
@property (nonatomic, assign, readonly)     BOOL have_comment;

@end