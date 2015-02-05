//
//  SCCarBrand.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/12.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCarBrand.h"

@implementation SCCarBrand

#pragma mark - Setter And Getter Methods
- (void)setBrand_id:(NSString<Optional> *)brand_id
{
    _brand_id = brand_id;
    _img_name = [brand_id stringByAppendingString:@".png"];
}

@end
