//
//  SCReservationTableViewCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/11.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCReservationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *merchantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *reservationTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *reservationDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *maintenanceScheduleLabel;
@property (weak, nonatomic) IBOutlet UILabel *showMoreLabel;

@end
