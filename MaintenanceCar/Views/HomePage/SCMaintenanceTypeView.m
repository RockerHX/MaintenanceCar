//
//  SCMaintenanceTypeView
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/18.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMaintenanceTypeView.h"
#import "MicroCommon.h"

@interface SCMaintenanceTypeView () <SCMaintenanceTypeItemDelegate>
{
    SCMaintenanceTypeItem *_preTypeView;
}

@end

@implementation SCMaintenanceTypeView

#pragma mark - Init Methods
- (void)awakeFromNib
{
    _normalItem.type       = SCMaintenanceTypeNormal;
    _accurateItem.type     = SCMaintenanceTypeAccurate;
    _selfItem.type         = SCMaintenanceTypeSelf;

    _normalItem.delegate   = self;
    _accurateItem.delegate = self;
    _selfItem.delegate     = self;

    _preTypeView           = _selfItem;
    _maintenanceType       = SCMaintenanceTypeSelf;
}

#pragma mark - Private Methods
- (void)typeViewSelected:(SCMaintenanceTypeItem *)typeView
{
    if (typeView != _preTypeView)
    {
        [_preTypeView unSelected];
        
        _preTypeView     = typeView;
        _maintenanceType = typeView.type;
        if (_delegate && [_delegate respondsToSelector:@selector(didSelectedMaintenanceType:)])
            [_delegate didSelectedMaintenanceType:typeView.type];
    }
}

#pragma mark - Setter And Getter Methods
- (void)setMaintenanceType:(SCMaintenanceType)maintenanceType
{
    _maintenanceType = maintenanceType;
    
    switch (maintenanceType)
    {
        case SCMaintenanceTypeAccurate:
        {
            [self typeViewSelected:_accurateItem];
            [_accurateItem selected];
        }
            break;
        case SCMaintenanceTypeSelf:
        {
            [self typeViewSelected:_selfItem];
            [_selfItem selected];
        }
            break;
            
        default:
        {
            [self typeViewSelected:_normalItem];
            [_normalItem selected];
        }
            break;
    }
}

@end
