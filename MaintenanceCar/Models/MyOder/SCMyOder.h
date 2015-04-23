//
//  SCMyOder.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/23.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "JSONModel.h"

@interface SCMyOder : JSONModel

@property (nonatomic, strong) NSString *type;                   // 订单类型
@property (nonatomic, strong) NSString *reserveID;              // 预约ID
@property (nonatomic, strong) NSString *carModelName;           // 车辆车型
@property (nonatomic, strong) NSString *serviceName;            // 预约名称
@property (nonatomic, strong) NSString *merchantName;           // 商家名称
@property (nonatomic, strong) NSString *previousStateDate;      // 上个进度时间
@property (nonatomic, strong) NSString *previousStateName;      // 上个进度名称
@property (nonatomic, strong) NSString *currentStateDate;       // 当前进度时间
@property (nonatomic, strong) NSString *currentStateName;       // 当前进度名称
@property (nonatomic, strong) NSString *nextStateDate;          // 下个进度时间
@property (nonatomic, strong) NSString *nextStateName;          // 下个进度名称
@property (nonatomic, strong) NSString *merchantTelphone;       // 商家电话

@property (nonatomic, strong, readonly) NSString <Ignore>*typeImageName;      // 订单类型的提示图片名称

@end
