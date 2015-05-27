//
//  SCCarModel.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/14.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "JSONModel.h"

// 车辆车型数据Model
@interface SCCarModel : JSONModel

@property (nonatomic, strong) NSString <Optional> *model_id;      // 车辆车型ID
@property (nonatomic, strong) NSString <Optional> *brand_id;      // 车辆品牌ID
@property (nonatomic, strong) NSString <Optional> *model_name;    // 车辆车型名称
@property (nonatomic, strong) NSString <Optional> *create_time;   // 车辆车型数据创建时间
@property (nonatomic, strong) NSString <Optional> *memo;          // 备注

@end