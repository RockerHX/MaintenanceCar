//
//  SCCarModel.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/14.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "JSONModel.h"

@interface SCCarModel : JSONModel

@property (nonatomic, copy)             NSString <Optional>*model_id;
@property (nonatomic, copy)             NSString <Optional>*brand_id;
@property (nonatomic, copy)             NSString <Optional>*memo;
@property (nonatomic, copy)             NSString <Optional>*model_name;
@property (nonatomic, copy)             NSString <Optional>*create_time;

@property (nonatomic, strong, readonly) NSArray    <Ignore>*localData;

- (BOOL)save;

@end