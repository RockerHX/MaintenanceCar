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
@property (nonatomic, copy) NSString <Optional>*series_id;      // 车辆系列ID
@property (nonatomic, copy) NSString <Optional>*brand_name;     // 车辆品牌名称
@property (nonatomic, copy) NSString <Optional>*series_name;    // 车辆系列名称
@property (nonatomic, copy) NSString <Optional>*brand_init;     // 车辆品牌索引
@property (nonatomic, copy) NSString <Optional>*img_name;       // 车辆品牌logo
@property (nonatomic, copy) NSString <Optional>*brand_owner;    // 车辆所属
@property (nonatomic, copy) NSString <Optional>*hit_count;      //
@property (nonatomic, copy) NSString <Optional>*status;         // 
@property (nonatomic, copy) NSString <Optional>*create_time;    // 车辆品牌数据创建时间

/**
 *  数据保存到CoreData
 *
 *  @return 是否保存成功
 */
- (BOOL)save;

@end
