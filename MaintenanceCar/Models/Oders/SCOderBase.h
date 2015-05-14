//
//  SCOderBase.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/27.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "JSONModel.h"

@interface SCOderBase : JSONModel

@property (nonatomic, strong) NSString *type;                   // 订单类型
@property (nonatomic, strong) NSString *reserveID;              // 预约ID
@property (nonatomic, strong) NSString *companyID;              // 预约ID
@property (nonatomic, strong) NSString *carModelName;           // 车辆车型
@property (nonatomic, strong) NSString *serviceName;            // 预约名称
@property (nonatomic, strong) NSString *merchantName;           // 商家名称
@property (nonatomic, strong) NSString *merchantTelphone;       // 商家电话

@property (nonatomic, strong, readonly) NSString <Ignore>*typeImageName;      // 订单类型的提示图片名称

+ (NSDictionary *)baseKeyMapper;

@end
