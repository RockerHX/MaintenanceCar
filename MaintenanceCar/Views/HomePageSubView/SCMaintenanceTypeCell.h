//
//  SCMaintenanceTypeCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/18.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMaintenanceTableViewCell.h"
#import "SCMaintenanceTypeView.h"

@class SCMaintenanceTypeView;

@interface SCMaintenanceTypeCell : SCMaintenanceTableViewCell

@property (weak, nonatomic) IBOutlet SCMaintenanceTypeView *normalMaintenance;
@property (weak, nonatomic) IBOutlet SCMaintenanceTypeView *accurateMaintenance;
@property (weak, nonatomic) IBOutlet SCMaintenanceTypeView *selfMaintenance;

@property (nonatomic, assign)        SCMaintenanceType     maintenanceType;

@end
