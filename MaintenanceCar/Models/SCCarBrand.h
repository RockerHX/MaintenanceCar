//
//  SCCarBrand.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/12.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "JSONModel.h"

// 车辆品牌数据Model
@interface SCCarBrand : JSONModel

@property (nonatomic, copy) NSString <Optional>*brand_id;       // 车辆品牌ID
@property (nonatomic, copy) NSString <Optional>*brand_init;     // 车辆品牌索引
@property (nonatomic, copy) NSString <Optional>*brand_name;     // 车辆品牌名称
@property (nonatomic, copy) NSString   <Ignore>*img_name;       // 车辆品牌logo

@end
