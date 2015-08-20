//
//  SCGroupTicket.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCGroupTicket.h"

@implementation SCGroupTicket

#pragma Class Methods
+ (instancetype)objectWithKeyValues:(id)keyValues {
    SCGroupTicket *ticket = [super objectWithKeyValues:keyValues];
    [ticket ticketState];
    return ticket;
}

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"ID": @"group_ticket_id",
      @"companyID": @"company_id",
      @"productID": @"product_id",
     @"limitBegin": @"limit_begin",
       @"limitEnd": @"limit_end",
         @"userID": @"user_id",
      @"reserveID": @"reservation",
      @"sellCount": @"sell_count",
     @"finalPrice": @"final_price",
     @"totalPrice": @"total_price",
    @"companyName": @"company_name"};
}

#pragma mark - Public Methods
- (BOOL)expired {
    return ([self expiredInterval] < 0);
}

- (NSString *)expiredPrompt {
    NSTimeInterval expiredInterval = [self expiredInterval] / (60*60*24);
    
    return [self expired] ? @"": [NSString stringWithFormat:@"还有%@天过期", @((NSInteger)expiredInterval)];
}

#pragma mark - Private Methods
- (NSTimeInterval)expiredInterval {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *expiredDate = [formatter dateFromString:_limitEnd];
    NSDate *serviceDate = [formatter dateFromString:_now];
    NSTimeInterval expiredInterval = [expiredDate timeIntervalSinceDate:serviceDate];
    
    return expiredInterval;
}

- (void)ticketState {
    SCGroupTicketState state;
    switch ([_status integerValue])
    {
        case 0:
            state = SCGroupTicketStateUnUse;
            break;
        case 1:
            state = SCGroupTicketStateUsed;
            break;
        case 2:
            state = SCGroupTicketStateCancel;
            break;
        case 3:
            state = SCGroupTicketStateExpired;
            break;
        case 4:
            state = SCGroupTicketStateRefunding;
            break;
        case 5:
            state = SCGroupTicketStateRefunded;
            break;
        case 6:
            state = SCGroupTicketStateReserved;
            break;
            
        default:
            state = [self expired] ? SCGroupTicketStateExpired : SCGroupTicketStateUnknown;
            break;
    }
    _state = state;
}

@end
