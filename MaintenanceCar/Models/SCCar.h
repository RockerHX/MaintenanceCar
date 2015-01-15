//
//  SCCar.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/14.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "JSONModel.h"

@interface SCCar : JSONModel

@property (nonatomic, copy) NSString <Optional>*car_id;
@property (nonatomic, copy) NSString <Optional>*model_id;
@property (nonatomic, copy) NSString <Optional>*brand_id;
@property (nonatomic, copy) NSString <Optional>*brand_Initials;
@property (nonatomic, copy) NSString <Optional>*car_full_model;
@property (nonatomic, copy) NSString <Optional>*car_displacement;
@property (nonatomic, copy) NSString <Optional>*up_time;
@property (nonatomic, copy) NSString <Optional>*car_type;
@property (nonatomic, copy) NSString <Optional>*gearbox;
@property (nonatomic, copy) NSString <Optional>*brand_country;
@property (nonatomic, copy) NSString <Optional>*tech_owner;
@property (nonatomic, copy) NSString <Optional>*car_option;
@property (nonatomic, copy) NSString <Optional>*turbo;
@property (nonatomic, copy) NSString <Optional>*grade;
@property (nonatomic, copy) NSString <Optional>*create_time;
@property (nonatomic, copy) NSString <Optional>*update_time;

@property (nonatomic, strong, readonly) NSArray    <Ignore>*localData;

- (BOOL)save;

@end
