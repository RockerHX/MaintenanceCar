//
//  SCMerchant.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/26.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "JSONModel.h"
#import "SCMerchantDetail.h"

@interface SCMerchant : JSONModel

@property (nonatomic, strong) NSArray          *attribute;
@property (nonatomic, strong) SCMerchantDetail *fields;
@property (nonatomic, strong) NSArray          *property;
@property (nonatomic, strong) NSArray          *sortExprValues;
@property (nonatomic, strong) NSDictionary     *variableValue;

@end
