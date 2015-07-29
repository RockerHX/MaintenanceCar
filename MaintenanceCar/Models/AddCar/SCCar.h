//
//  SCCar.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/14.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "JSONModel.h"

// 车辆型号数据Model
@interface SCCar : JSONModel

@property (nonatomic, strong) NSString <Optional>*car_id;                 // 车辆型号ID
@property (nonatomic, strong) NSString <Optional>*user_car_id;            // 用户车辆ID
@property (nonatomic, strong) NSString <Optional>*model_id;               // 车辆车型ID
@property (nonatomic, strong) NSString <Optional>*car_full_model;         // 车辆型号全称
@property (nonatomic, strong) NSString <Optional>*up_time;                // 车辆型号出厂年份
@property (nonatomic, strong) NSString <Optional>*brand_name;             // 车辆品牌名称
@property (nonatomic, strong) NSString <Optional>*model_name;             // 车型名称

@end
