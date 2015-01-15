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
@property (nonatomic, copy) NSString <Optional>*brand_id;               // 车辆品牌ID
@property (nonatomic, copy) NSString <Optional>*brand_Initials;         //
@property (nonatomic, copy) NSString <Optional>*car_full_model;         // 车辆型号全称
@property (nonatomic, copy) NSString <Optional>*car_displacement;       //
@property (nonatomic, copy) NSString <Optional>*up_time;                // 车辆型号出厂年份
@property (nonatomic, copy) NSString <Optional>*car_type;               // 车辆类型
@property (nonatomic, copy) NSString <Optional>*gearbox;                // 制动类型
@property (nonatomic, copy) NSString <Optional>*brand_country;          // 车辆所属国家
@property (nonatomic, copy) NSString <Optional>*tech_owner;             //
@property (nonatomic, copy) NSString <Optional>*car_option;             //
@property (nonatomic, copy) NSString <Optional>*turbo;                  // 车辆是否有turbo引擎
@property (nonatomic, copy) NSString <Optional>*grade;                  //
@property (nonatomic, copy) NSString <Optional>*create_time;            // 车辆信号数据创建时间
@property (nonatomic, copy) NSString <Optional>*update_time;            // 车辆型号数据更新时间

@property (nonatomic, strong, readonly) NSArray    <Ignore>*localData;  // 车辆信号本地缓存数据

/**
 *  数据保存到CoreData
 *
 *  @return 是否保存成功
 */
- (BOOL)save;

@end
