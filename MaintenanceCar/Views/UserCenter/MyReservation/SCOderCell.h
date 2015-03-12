//
//  SCOderCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/11.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MicroCommon.h"

@class SCReservation;

@interface SCOderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *merchantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *reservationTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *reservationDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *scheduleLabel;
@property (weak, nonatomic) IBOutlet UILabel *carInfoLabel;

- (void)displayCellWithReservation:(SCReservation *)reservation;

@end
