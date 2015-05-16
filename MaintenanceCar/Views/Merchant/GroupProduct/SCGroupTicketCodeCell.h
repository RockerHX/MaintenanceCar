//
//  SCGroupTicketCodeCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCGroupTicket.h"

@protocol SCGroupTicketCodeCellDelegate <NSObject>

@optional
- (void)ticketShouldReservationWithIndex:(NSInteger)index;
- (void)ticketShouldShowWithIndex:(NSInteger)index;

@end

@interface SCGroupTicketCodeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet            UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet           UIButton *reservationButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reservationButtonWidith;

@property (nonatomic, weak)                id  <SCGroupTicketCodeCellDelegate>delegate;

- (IBAction)reservationButtonPressed:(id)sender;

- (void)displayCellWithTicket:(SCGroupTicket *)ticket index:(NSInteger)index;

@end
