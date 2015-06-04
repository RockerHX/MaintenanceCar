//
//  SCGroupTicket.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "JSONModel.h"

typedef NS_ENUM(NSInteger, SCGroupTicketState) {
    SCGroupTicketStateUnUse,
    SCGroupTicketStateUsed,
    SCGroupTicketStateCancel,
    SCGroupTicketStateExpired,
    SCGroupTicketStateRefunding,
    SCGroupTicketStateRefunded,
    SCGroupTicketStateReserved,
    SCGroupTicketStateUnknown
};

@interface SCGroupTicket : JSONModel

@property (nonatomic, strong) NSString <Optional>*group_ticket_id;
@property (nonatomic, strong) NSString <Optional>*company_id;
@property (nonatomic, strong) NSString <Optional>*code;
@property (nonatomic, strong) NSString <Optional>*product_id;
@property (nonatomic, strong) NSString <Optional>*limit_begin;
@property (nonatomic, strong) NSString <Optional>*limit_end;
@property (nonatomic, strong) NSString <Optional>*user_id;
@property (nonatomic, strong) NSString <Optional>*type;
@property (nonatomic, strong) NSString <Optional>*title;
@property (nonatomic, strong) NSString <Optional>*sell_count;
@property (nonatomic, strong) NSString <Optional>*status;
@property (nonatomic, strong) NSString <Optional>*final_price;
@property (nonatomic, strong) NSString <Optional>*total_price;
@property (nonatomic, strong) NSString <Optional>*company_name;
@property (nonatomic, strong) NSString <Optional>*now;

@property (nonatomic, assign, readonly) SCGroupTicketState state;

- (BOOL)expired;
- (NSString *)expiredPrompt;

@end
