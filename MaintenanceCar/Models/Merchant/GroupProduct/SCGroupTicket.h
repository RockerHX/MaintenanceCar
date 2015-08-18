//
//  SCGroupTicket.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <MJExtension/MJExtension.h>

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

@interface SCGroupTicket : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *companyID;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *productID;
@property (nonatomic, copy) NSString *limitBegin;
@property (nonatomic, copy) NSString *limitEnd;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *reserveID;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *sellCount;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *finalPrice;
@property (nonatomic, copy) NSString *totalPrice;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *now;

@property (nonatomic, assign) SCGroupTicketState state;

- (BOOL)expired;
- (NSString *)expiredPrompt;

@end
