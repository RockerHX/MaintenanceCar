//
//  SCMaintenanceTypeCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/18.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMaintenanceTypeCell.h"

@interface SCMaintenanceTypeCell () <SCMaintenanceTypeViewDelegate>
{
    SCMaintenanceTypeView *_preTypeView;
}

@end

@implementation SCMaintenanceTypeCell

- (id)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    }
    return self;
}

- (void)awakeFromNib
{
    _normalMaintenance.type       = SCMaintenanceTypeNormal;
    _accurateMaintenance.type     = SCMaintenanceTypeAccurate;
    _selfMaintenance.type         = SCMaintenanceTypeSelf;

    _normalMaintenance.delegate   = self;
    _accurateMaintenance.delegate = self;
    _selfMaintenance.delegate     = self;

    _preTypeView                  = _normalMaintenance;
    _maintenanceType              = SCMaintenanceTypeNormal;
}

- (void)typeViewSelected:(SCMaintenanceTypeView *)typeView
{
    if (typeView != _preTypeView)
    {
        [_preTypeView unSelected];
        
        _preTypeView     = typeView;
        _maintenanceType = typeView.type;
    }
}

@end
