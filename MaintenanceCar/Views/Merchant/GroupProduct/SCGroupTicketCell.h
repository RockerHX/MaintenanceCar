//
//  SCGroupTicketCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCGroupTicketCodeCell.h"

@interface SCGroupTicketCell : SCGroupTicketCodeCell

@property (weak, nonatomic) IBOutlet UILabel *merchantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketStateLabel;
@property (weak, nonatomic) IBOutlet  UIView *codeLine;

@end
