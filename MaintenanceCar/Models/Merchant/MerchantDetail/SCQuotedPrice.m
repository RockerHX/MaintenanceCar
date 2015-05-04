//
//  SCQuotedPrice.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCQuotedPrice.h"

@implementation SCQuotedPrice

- (id)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    self = [super initWithDictionary:dict error:err];
    if (self)
    {
        _final_price = _final_price ? _final_price : @"";
    }
    return self;
}

@end
