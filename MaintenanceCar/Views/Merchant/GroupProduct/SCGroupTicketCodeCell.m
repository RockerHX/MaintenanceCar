//
//  SCGroupTicketCodeCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCGroupTicketCodeCell.h"

@implementation SCGroupTicketCodeCell
{
    SCGroupTicket *_ticket;
}

#pragma mark - Init Methods
- (void)awakeFromNib
{
    _reservationButton.layer.cornerRadius = 3.0f;
    _reservationButton.layer.borderWidth  = 1.0f;
    _reservationButton.layer.borderColor  = [UIColor orangeColor].CGColor;
}

#pragma mark - Action Methods
- (IBAction)reservationButtonPressed:(id)sender
{
    if (_ticket.state == SCGroupTicketStateUnUse)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(ticketShouldReservationWithIndex:)])
            [_delegate ticketShouldReservationWithIndex:self.tag];
    }
    else if (_ticket.state == SCGroupTicketStateReserved)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(ticketShouldShowWithIndex:)])
            [_delegate ticketShouldShowWithIndex:self.tag];
    }
}

#pragma mark - Public Methods
- (void)displayCellWithTicket:(SCGroupTicket *)ticket index:(NSInteger)index
{
    self.tag = index;
    _ticket = ticket;
    _codeLabel.text = ticket.code;
    
    BOOL hidden = NO;
    switch (ticket.state)
    {
        case SCGroupTicketStateUnUse:
        case SCGroupTicketStateReserved:
            break;
            
        default:
            hidden = YES;
            break;
    }
    _reservationButton.hidden = [ticket expired] || hidden;
    
    NSString *buttonTitle = nil;
    if (ticket.state == SCGroupTicketStateReserved)
    {
        buttonTitle = @"查看预约";
        _reservationButtonWidith.constant = 70.0f;
    }
    else if (ticket.state == SCGroupTicketStateUnUse)
        buttonTitle = @"预约";
    [_reservationButton setTitle:buttonTitle forState:UIControlStateNormal];
}

@end
