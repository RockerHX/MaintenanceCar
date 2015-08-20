//
//  SCOrderBase.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/27.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <MJExtension/MJExtension.h>

@interface SCOrderBase : NSObject

@property (nonatomic, copy) NSString *type;                   // 订单类型
@property (nonatomic, copy) NSString *reserveID;              // 预约ID
@property (nonatomic, copy) NSString *companyID;              // 预约ID
@property (nonatomic, copy) NSString *carModelName;           // 车辆车型
@property (nonatomic, copy) NSString *serviceName;            // 预约名称
@property (nonatomic, copy) NSString *merchantName;           // 商家名称
@property (nonatomic, copy) NSString *merchantTelphone;       // 商家电话

@property (nonatomic, copy, readonly) NSString *typeImageName;      // 订单类型的提示图片名称

@end
