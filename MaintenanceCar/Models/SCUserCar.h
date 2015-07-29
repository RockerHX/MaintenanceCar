//
//  SCUserCar.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/18.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCar.h"

@interface SCUserCar : SCCar

@property (nonatomic, strong) NSString <Optional>*plate;                  // 牌照
@property (nonatomic, strong) NSString <Optional>*buy_car_year;           // 购买年份
@property (nonatomic, strong) NSString <Optional>*buy_car_month;          // 购买月份
@property (nonatomic, strong) NSString <Optional>*run_distance;           // 里程数
@property (nonatomic, strong) NSString <Optional>*run_distance_stamp;     // 里程时间
@property (nonatomic, strong) NSString <Optional>*habit;                  // 驾驶习惯
@property (nonatomic, strong) NSString <Optional>*memo;                   // 备注

@property (nonatomic, strong) NSArray <Ignore>*normalItems;             // 保养数据 - 普保
@property (nonatomic, strong) NSArray <Ignore>*carefulItems;            // 保养数据 - 精保
@property (nonatomic, strong) NSArray <Ignore>*allItems;                // 保养数据 - 自选


- (id)initWithCar:(SCCar *)car;

@end