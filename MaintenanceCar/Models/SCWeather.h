//
//  SCWeather.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/24.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "JSONModel.h"

@interface SCWeather : JSONModel

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *zs;
@property (nonatomic, strong) NSString *tipt;
@property (nonatomic, strong) NSString *des;

@end
