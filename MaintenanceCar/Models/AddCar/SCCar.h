//
//  SCCar.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/14.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <MJExtension/MJExtension.h>

// 车辆型号数据Model
@interface SCCar : NSObject

@property (nonatomic, copy) NSString *carID;                // 车辆型号ID
@property (nonatomic, copy) NSString *userCarID;            // 用户车辆ID
@property (nonatomic, copy) NSString *modelID;              // 车辆车型ID
@property (nonatomic, copy) NSString *brandID;              // 车辆品牌ID
@property (nonatomic, copy) NSString *carFullModel;         // 车辆型号全称
@property (nonatomic, copy) NSString *upTime;               // 车辆型号出厂年份
@property (nonatomic, copy) NSString *brandName;            // 车辆品牌名称
@property (nonatomic, copy) NSString *modelName;            // 车型名称

@property (nonatomic, copy) NSString *iconURL;              // 车辆Logo

@end
