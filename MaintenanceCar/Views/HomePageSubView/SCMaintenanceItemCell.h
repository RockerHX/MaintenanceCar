//
//  SCMaintenanceItemCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/18.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMaintenanceTableViewCell.h"

@interface SCMaintenanceItemCell : SCMaintenanceTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *checkBox;
@property (weak, nonatomic) IBOutlet     UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet     UILabel *memoLabel;

@property (nonatomic, assign)               BOOL check;

@end
