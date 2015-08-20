//
//  SCUserCar.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/18.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCUserCar.h"

@implementation SCUserCar

- (instancetype)initWithCar:(SCCar *)car {
    SCUserCar *userCar = [SCUserCar objectWithKeyValues:car.keyValues];
    return userCar;
}

+ (NSDictionary *)replacedKeyFromPropertyName {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[super replacedKeyFromPropertyName]];
    [dic setValuesForKeysWithDictionary:@{@"buyCarYear": @"buy_car_year",
                                         @"buyCarMonth": @"buy_car_month",
                                         @"runDistance": @"run_distance",
                                    @"runDistanceDtamp": @"run_distance_stamp"}];
    return dic;
}

@end
