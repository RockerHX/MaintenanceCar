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
- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err{
    self = [super initWithDictionary:dict error:err];
    if (self){
        NSString *pricePrompt = [_price stringByAppendingString:@"元"];
        _pricePrompt = _isPay ? pricePrompt : ([_price doubleValue] ? pricePrompt : @"待确定");
    }
    return self;
}

#pragma mark - Class Methods
+ (JSONKeyMapper *)keyMapper {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self baseKeyMapper]];
    [dic addEntriesFromDictionary:@{@"create_time": @"orderDate",
                                    @"arrive_time": @"arriveDate",
                                   @"reserve_name": @"reserveUser",
                                  @"reserve_phone": @"reservePhone",
                                        @"content": @"remark",
                                     @"can_cancel": @"canCancel",
                                        @"can_pay": @"canPay",
                                         @"is_pay": @"isPay",
                                        @"process": @"processes"}];
    return [[JSONKeyMapper alloc] initWithDictionary:dic];
}

@end
