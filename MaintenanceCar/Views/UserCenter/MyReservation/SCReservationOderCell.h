//
//  SCReservationOderCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/11.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllMicroConstants.h"
#import "SCReservation.h"

@interface SCReservationOderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *merchantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *reservationTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *createDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *scheduleLabel;
@property (weak, nonatomic) IBOutlet UILabel *carInfoLabel;

@property (weak, nonatomic, readonly) SCReservation *reservation;

- (void)displayCellWithReservation:(SCReservation *)reservation;

@end
