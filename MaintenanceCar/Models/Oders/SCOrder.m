//
//  SCOrder.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/23.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCOrder.h"

@implementation SCOrder

#pragma mark - Class Methods
+ (JSONKeyMapper *)keyMapper
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self baseKeyMapper]];
    [dic addEntriesFromDictionary:@{@"previous_time": @"previousStateDate",
                                    @"previous_name": @"previousStateName",
                                     @"current_time": @"currentStateDate",
                                     @"current_name": @"currentStateName",
                                        @"next_time": @"nextStateDate",
                                        @"next_name": @"nextStateName",
                                      @"can_comment": @"canComment"}];
    return [[JSONKeyMapper alloc] initWithDictionary:dic];
}

@end
