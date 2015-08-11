//
//  SCCar.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/14.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCar.h"
#import "SCApi.h"

@implementation SCCar

+ (instancetype)objectWithKeyValues:(id)keyValues {
    SCCar *car = [super objectWithKeyValues:keyValues];
    car.iconURL = [SCApi imageURLWithImageName:[NSString stringWithFormat:@"%@.png", car.brandID]];
    return car;
}

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"carID": @"car_id",
         @"userCarID": @"user_car_id",
           @"modelID": @"model_id",
           @"brandID": @"brand_id",
      @"carFullModel": @"car_full_model",
            @"upTime": @"up_time",
         @"brandName": @"brand_name",
         @"modelName": @"model_name"};
}

@end
