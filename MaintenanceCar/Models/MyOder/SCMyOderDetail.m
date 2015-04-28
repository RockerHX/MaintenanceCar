//
//  SCMyOderDetail.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/27.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMyOderDetail.h"

@implementation SCMyOderDetailProgress

@end

@implementation SCMyOderDetail

#pragma mark - Class Methods
+ (JSONKeyMapper *)keyMapper
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self baseKeyMapper]];
    [dic addEntriesFromDictionary:@{@"create_time": @"oderDate",
                                    @"arrive_time": @"arriveDate",
                                   @"reserve_name": @"reserveUser",
                                  @"reserve_phone": @"reservePhone",
                                        @"content": @"remark",
                                     @"can_cancel": @"canCancel",
                                        @"process": @"processes"}];
    return [[JSONKeyMapper alloc] initWithDictionary:dic];
}

@end
