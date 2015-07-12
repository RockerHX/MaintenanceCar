//
//  SCPayOderTicketCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/28.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCPayOderTicketCell.h"

@implementation SCPayOderTicketCell

#pragma mark - Setter And Getter Methods
- (void)setFrame:(CGRect)frame
{
    frame.origin.y = frame.origin.y - 10.0f;
    frame.size.height = frame.size.height + 10.0f;
    [super setFrame:frame];
}

#pragma mark - Public Methods
- (void)displayCellWithTickets:(NSArray *)tickets index:(NSInteger)index
{
    CGFloat width = SELF_WIDTH;
    CGFloat height = SELF_HEIGHT;
    UIBezierPath *path = [self shadowPathWithPoints:@[@[@(ZERO_POINT), @(-SHADOW_OFFSET*4)],
                                                      @[@(ZERO_POINT), @(height)],
                                                      @[@(SHADOW_OFFSET*2), @(height - SHADOW_OFFSET*6)],
                                                      @[@(width - SHADOW_OFFSET*2), @(height - SHADOW_OFFSET*6)],
                                                      @[@(width), @(height + SHADOW_OFFSET*4)],
                                                      @[@(width), @(-SHADOW_OFFSET*4)],
                                                      @[@(width - SHADOW_OFFSET*2), @(SHADOW_OFFSET*6)],
                                                      @[@(SHADOW_OFFSET*2), @(SHADOW_OFFSET*6)]]];
    self.layer.shadowPath = path.CGPath;
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(SHADOW_OFFSET, SHADOW_OFFSET);
    self.layer.shadowOpacity = 1.0f;
    self.layer.shadowRadius = 1.0f;
    SCGroupTicket *ticket = tickets[index];
    if (index == (tickets.count - 1))
        self.layer.shadowPath = nil;
    
    _codeLabel.text = ticket.code;
}

@end
