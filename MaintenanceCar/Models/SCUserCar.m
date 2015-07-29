//
//  SCUserCar.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/18.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCUserCar.h"

@implementation SCUserCar

- (id)initWithCar:(SCCar *)car
{
    self = [super init];
    if (self)
    {
        self.car_id      = car.car_id;
        self.user_car_id = car.user_car_id;
        self.model_id    = car.model_id;
        self.up_time     = car.up_time;
        self.brand_name  = car.brand_name;
        self.model_name  = car.model_name;
    }
    return self;
}

@end
