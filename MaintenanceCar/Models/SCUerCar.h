//
//  SCUerCar.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/18.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "JSONModel.h"

@interface SCUerCar : JSONModel

@property (nonatomic, copy) NSString <Optional>*user_car_id;            // 用户车辆ID
@property (nonatomic, copy) NSString <Optional>*car_id;                 // 车辆型号ID
@property (nonatomic, copy) NSString <Optional>*model_id;               // 车辆车型ID
@property (nonatomic, copy) NSString <Optional>*plate;                  // 牌照
@property (nonatomic, copy) NSString <Optional>*buy_car_year;           // 购买年份
@property (nonatomic, copy) NSString <Optional>*buy_car_month;          // 购买月份
@property (nonatomic, copy) NSString <Optional>*run_distance;           // 里程数
@property (nonatomic, copy) NSString <Optional>*run_distance_stamp;     // 里程时间
@property (nonatomic, copy) NSString <Optional>*model_name;             // 车型名称
@property (nonatomic, copy) NSString <Optional>*habit;                  // 驾驶习惯
@property (nonatomic, copy) NSString <Optional>*memo;                   // 备注

@property (nonatomic, strong) NSArray <Ignore>*normalItems;             // 保养数据 - 普保
@property (nonatomic, strong) NSArray <Ignore>*carefulItems;            // 保养数据 - 精保
@property (nonatomic, strong) NSArray <Ignore>*allItems;                // 保养数据 - 自选

@end
