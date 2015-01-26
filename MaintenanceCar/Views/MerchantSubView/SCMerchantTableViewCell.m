//
//  SCMerchantTableViewCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/26.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCMerchantTableViewCell.h"
#import "MicroCommon.h"

@implementation SCMerchantTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    
    // 绘制圆角
    _merchantIcon.layer.cornerRadius = 3.0f;
    _reservationButton.layer.cornerRadius = 6.0f;
    
    // 绘制边框和圆角
    _specialLabel.layer.cornerRadius = 2.0f;
    _specialLabel.layer.borderWidth = 1.0f;
    _specialLabel.layer.borderColor = UIColorWithRGBA(230.0f, 109.0f, 81.0f, 1.0f).CGColor;
    
    
    if (IS_IPHONE_5_PRIOR || IS_IPHONE_5)
    {
        if (IS_IOS8)
            [self performSelector:@selector(viewConfig) withObject:nil afterDelay:0.1f];
        else
            [self viewConfig];
    }
}

- (void)viewConfig
{
    _buttonWidth.constant = 66.0f;
    [_reservationButton needsUpdateConstraints];
    [UIView animateWithDuration:0.3f animations:^{
        [_reservationButton layoutIfNeeded];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)reservationButtonPressed:(UIButton *)sender
{
    // 当[预约]按钮被点击，发送消息通知SCMerchantViewController获取index
    [NOTIFICATION_CENTER postNotificationName:kMaintenanceReservationNotification object:@(sender.tag)];
}

@end
