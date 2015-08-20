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
+ (NSDictionary *)replacedKeyFromPropertyName {
    NSMutableDictionary *propertyNames = [super replacedKeyFromPropertyName].mutableCopy;
    [propertyNames addEntriesFromDictionary:@{@"previousStateDate": @"previous_time",
                                              @"previousStateName": @"previous_name",
                                               @"currentStateDate": @"current_time",
                                               @"currentStateName": @"current_name",
                                                  @"nextStateDate": @"next_time",
                                                  @"nextStateName": @"next_name",
                                                     @"canComment": @"can_comment"}];
    return [NSDictionary dictionaryWithDictionary:propertyNames];
}

@end
