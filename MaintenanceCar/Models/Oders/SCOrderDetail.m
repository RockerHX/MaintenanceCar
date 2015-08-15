//
//  SCOrderDetail.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/27.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCOrderDetail.h"


@implementation SCOrderDetailProgress
@end


@implementation SCOrderDetail

#pragma mark - Init Methods
+ (instancetype)objectWithKeyValues:(id)keyValues {
    [SCOrderDetail setupObjectClassInArray:^NSDictionary *{
        return @{@"processes": @"SCOrderDetailProgress"};
    }];
    SCOrderDetail *detail = [super objectWithKeyValues:keyValues];
    NSString *pricePrompt = [detail.price stringByAppendingString:@"元"];
    detail.pricePrompt = detail.isPay ? pricePrompt : ([detail.price doubleValue] ? pricePrompt : @"待确定");
    return detail;
}

#pragma mark - Class Methods
+ (NSDictionary *)replacedKeyFromPropertyName {
    NSMutableDictionary *propertyNames = [super replacedKeyFromPropertyName].mutableCopy;
    [propertyNames addEntriesFromDictionary:@{@"orderDate": @"create_time",
                                             @"arriveDate": @"arrive_time",
                                            @"reserveUser": @"reserve_name",
                                           @"reservePhone": @"reserve_phone",
                                                 @"remark": @"content",
                                              @"canCancel": @"can_cancel",
                                                 @"canPay": @"can_pay",
                                                  @"isPay": @"is_pay",
                                              @"processes": @"process"}];
    return [NSDictionary dictionaryWithDictionary:propertyNames];
}

@end
