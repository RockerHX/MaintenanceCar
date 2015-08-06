//
//  SCGroupTicketCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCGroupTicketCell.h"
#import "SCGroupTicket.h"

@implementation SCGroupTicketCell

#pragma mark - Public Methods
- (void)displayCellWithTicket:(SCGroupTicket *)ticket index:(NSInteger)index {
    [super displayCellWithTicket:ticket index:index];
    
    _productNameLabel.text  = [ticket.title stringByAppendingString:@":"];
    _merchantNameLabel.text = ticket.company_name;
    _ticketPriceLabel.text  = ticket.final_price;
    _productPriceLabel.text = ticket.total_price;
    _ticketStateLabel.text  = [self codeStateWithTicket:ticket.state];
    
    _codeLine.hidden = ((ticket.state == SCGroupTicketStateUnUse) || (ticket.state == SCGroupTicketStateReserved));
    self.codeLabel.textColor = (ticket.state == SCGroupTicketStateUnUse) ? [UIColor orangeColor] : [UIColor lightGrayColor];
}

#pragma mark - Private Methods
- (NSString *)codeStateWithTicket:(SCGroupTicketState)state {
    NSString *codeState;
    switch (state) {
        case SCGroupTicketStateUnUse:
            codeState = @"未使用";
            break;
        case SCGroupTicketStateUsed:
            codeState = @"已使用";
            break;
        case SCGroupTicketStateCancel:
            codeState = @"已取消";
            break;
        case SCGroupTicketStateExpired:
            codeState = @"已过期";
            break;
        case SCGroupTicketStateRefunding:
            codeState = @"退款中";
            break;
        case SCGroupTicketStateRefunded:
            codeState = @"已退款";
            break;
        case SCGroupTicketStateReserved:
            codeState = @"已预约";
            break;
            
        default:
            codeState = @"-";
            break;
    }
    return codeState;
}

@end
