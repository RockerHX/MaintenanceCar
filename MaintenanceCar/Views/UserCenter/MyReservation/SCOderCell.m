//
//  SCOderCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/11.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCOderCell.h"

@implementation SCOderCell

#pragma mark - Init Methods
- (void)awakeFromNib
{
    _merchantNameLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 55.0f;
    
    // IOS7要改变删除按钮颜色必须设置editingAccessoryView
    UIView *deleteView = [[UIView alloc]initWithFrame:CGRectMake(ZERO_POINT, ZERO_POINT, 1.0f, 1.0f)];
    self.editingAccessoryView = deleteView;
    
    _scheduleLabel.layer.borderWidth = 1.0f;
    _createDateLabel.layer.borderColor = ThemeColor.CGColor;
    _createDateLabel.layer.borderWidth = 1.0f;
}

// IOS7只有didTransitionToState方法能获取到UITableViewCellDeleteConfirmationView
- (void)didTransitionToState:(UITableViewCellStateMask)state
{
    if ((CURRENT_SYSTEM_VERSION < 8.0f) && ![_reservation canUnReservation])
    {
        for (UIView *view in self.subviews)
        {
            for (UIView *subview in view.subviews)
            {
                if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"])
                    ((UIView*)[subview.subviews firstObject]).backgroundColor = [UIColor grayColor];
            }
        }
    }
}

#pragma mark - Public Methods
- (void)displayCellWithReservation:(SCReservation *)reservation
{
    _reservation = reservation;
    _merchantNameLabel.text    = reservation.name;
    _reservationTypeLabel.text = [NSString stringWithFormat:@"%@：", reservation.type];
    _scheduleLabel.text        = [NSString stringWithFormat:@"  %@  ", reservation.status];
    _createDateLabel.text      = reservation.create_time;
    _carInfoLabel.text         = reservation.car_model_name;
    
    _scheduleLabel.textColor = ([reservation.status isEqualToString:@"预约已取消"] || [reservation.status isEqualToString:@"已完成"] || [reservation.status isEqualToString:@"已过期"]) ? [UIColor grayColor] : [UIColor redColor];
    _scheduleLabel.layer.borderColor = _scheduleLabel.textColor.CGColor;
}

#pragma mark - Private Methods

@end
