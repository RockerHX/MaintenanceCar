//
//  SCCar.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/12.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "JSONModel.h"

@interface SCCar : JSONModel

@property (nonatomic, copy) NSString <Optional>*brand_id;
@property (nonatomic, copy) NSString <Optional>*brand_name;
@property (nonatomic, copy) NSString <Optional>*series_id;
@property (nonatomic, copy) NSString <Optional>*series_name;
@property (nonatomic, copy) NSString <Optional>*brand_init;
@property (nonatomic, copy) NSString <Optional>*img_name;
@property (nonatomic, copy) NSString <Optional>*brand_owner;
@property (nonatomic, copy) NSString <Optional>*hit_count;
@property (nonatomic, copy) NSString <Optional>*status;
@property (nonatomic, copy) NSString <Optional>*create_time;

@end
