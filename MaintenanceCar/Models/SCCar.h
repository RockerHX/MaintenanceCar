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

@property (nonatomic, copy) NSString <Optional>*car_id;                 // 车辆型号ID
@property (nonatomic, copy) NSString <Optional>*model_id;               // 车辆车型ID
@property (nonatomic, copy) NSString <Optional>*car_full_model;         // 车辆型号全称
@property (nonatomic, copy) NSString <Optional>*up_time;                // 车辆型号出厂年份

@property (nonatomic, strong, readonly) NSArray    <Ignore>*localData;  // 车辆信号本地缓存数据

/**
 *  数据保存到CoreData
 *
 *  @return 是否保存成功
 */
- (void)save;

@end
