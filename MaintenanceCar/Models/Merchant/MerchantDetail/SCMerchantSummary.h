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

@property (nonatomic, strong)           NSString *flag;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *prompt;
@property (nonatomic, strong, readonly) NSString *content;
@property (nonatomic, strong, readonly) NSString *imageName;
@property (nonatomic, strong, readonly) NSString *colorHex;

- (instancetype)initWithMerchantDetail:(SCMerchantDetail *)detail flag:(NSString *)flag;

@end


@interface SCMerchantSummary : SCMerchantDetailBase

@property (nonatomic, strong, readonly)  NSString *name;
@property (nonatomic, strong, readonly)  NSString *distance;
@property (nonatomic, strong, readonly)  NSString *star;

@property (nonatomic, strong, readonly) NSArray *flags;
@property (nonatomic, assign, readonly)     BOOL unReserve;
@property (nonatomic, assign, readonly)     BOOL have_comment;

@end