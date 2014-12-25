//
//  SCWeather.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/24.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "JSONModel.h"

@interface SCWeather : JSONModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *zs;
@property (nonatomic, copy) NSString *tipt;
@property (nonatomic, copy) NSString *des;

@end
