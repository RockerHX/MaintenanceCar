//
//  SCCar.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/14.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCar.h"

@implementation SCCar

- (id)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    self = [super initWithDictionary:dict error:err];
    if (self)
    {
        _car_id = @"";
    }
    return self;
}

@end
