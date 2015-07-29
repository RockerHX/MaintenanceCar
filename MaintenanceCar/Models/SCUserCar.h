//
//  SCUserCar.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/18.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCar.h"

@interface SCUserCar : SCCar

@property (nonatomic, copy) NSString *plate;                  // 牌照
@property (nonatomic, copy) NSString *buyCarYear;           // 购买年份
@property (nonatomic, copy) NSString *buyCarMonth;          // 购买月份
@property (nonatomic, copy) NSString *runDistance;           // 里程数
@property (nonatomic, copy) NSString *runDistanceStamp;     // 里程时间
@property (nonatomic, copy) NSString *habit;                  // 驾驶习惯
@property (nonatomic, copy) NSString *memo;                   // 备注

@property (nonatomic, strong) NSArray *normalItems;           // 保养数据 - 普保
@property (nonatomic, strong) NSArray *carefulItems;          // 保养数据 - 精保
@property (nonatomic, strong) NSArray *allItems;              // 保养数据 - 自选

- (instancetype)initWithCar:(SCCar *)car;

@end