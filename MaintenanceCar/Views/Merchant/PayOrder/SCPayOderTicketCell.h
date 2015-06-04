//
//  SCPayOderTicketCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/28.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCTableViewCell.h"
#import "SCGroupTicket.h"

@interface SCPayOderTicketCell : SCTableViewCell

@property (weak, nonatomic) IBOutlet  UILabel *codeLabel;

- (void)displayCellWithTickets:(NSArray *)tickets index:(NSInteger)index;

@end
