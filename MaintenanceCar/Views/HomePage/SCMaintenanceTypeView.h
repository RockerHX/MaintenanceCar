//
//  SCMaintenanceTypeView.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/18.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMaintenanceTableViewCell.h"
#import "SCMaintenanceTypeItem.h"

@protocol SCMaintenanceTypeViewDelegate <NSObject>

@optional
- (void)didSelectedMaintenanceType:(SCMaintenanceType)type;

@end

@interface SCMaintenanceTypeView : UIView

@property (weak, nonatomic) IBOutlet SCMaintenanceTypeItem *normalItem;
@property (weak, nonatomic) IBOutlet SCMaintenanceTypeItem *accurateItem;
@property (weak, nonatomic) IBOutlet SCMaintenanceTypeItem *selfItem;

@property (nonatomic, weak) IBOutlet                    id  <SCMaintenanceTypeViewDelegate>delegate;
@property (nonatomic, assign)            SCMaintenanceType  maintenanceType;

@end
