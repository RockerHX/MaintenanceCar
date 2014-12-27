//
//  SCMerchant.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/26.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "JSONModel.h"
#import "SCMerchantDetail.h"

// 商户Model
@interface SCMerchant : JSONModel

// 以下属性供Model解析，不建议调用
@property (nonatomic, strong) NSArray                    *attribute;
@property (nonatomic, strong) SCMerchantDetail           *fields;
@property (nonatomic, strong) NSArray                    *property;
@property (nonatomic, strong) NSArray                    *sortExprValues;
@property (nonatomic, strong) NSDictionary               *variableValue;

// 以下是建议调用的属性
@property (nonatomic, strong) SCMerchantDetail<Optional> *detail;           // 商户的详细信息
@property (nonatomic, copy)   NSString<Optional>         *distance;         // 手机当前位置与商户的距离

@end
