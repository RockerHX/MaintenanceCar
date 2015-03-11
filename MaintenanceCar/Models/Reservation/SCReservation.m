//
//  SCReservation.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCReservation.h"

@implementation SCReservation

#pragma mark - Init Mehtods
- (id)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    self = [super initWithDictionary:dict error:err];
    if (self)
    {
        _type = [NSString stringWithFormat:@"%@:", _type];
        _car_model_name = [NSString stringWithFormat:@"【%@】", _car_model_name];
    }
    return self;
}

@end
