//
//  SCOderUnAppraisalCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/11.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCReservationOderCell.h"

@protocol SCOderUnAppraisalCellDelegate <NSObject>

@optional
- (void)shouldAppraiseOderWithReservation:(SCReservation *)reservation;

@end

@interface SCOderUnAppraisalCell : SCReservationOderCell

@property (weak, nonatomic) IBOutlet UIButton *appraiseButton;

@property (weak, nonatomic)                id <SCOderUnAppraisalCellDelegate>delegate;

- (IBAction)appraiseButtonPressed:(id)sender;

@end
