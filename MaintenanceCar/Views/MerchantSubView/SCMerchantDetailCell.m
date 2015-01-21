//
//  SCMerchantDetailCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/18.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMerchantDetailCell.h"
#import "MicroCommon.h"

@implementation SCMerchantDetailCell

- (void)awakeFromNib
{
    // Initialization code
    
    // 绘制圆角
    _reservationButton.layer.cornerRadius = 6.0f;
    
    // 绘制边框和圆角
    _specialLabel.layer.cornerRadius = 2.0f;
    _specialLabel.layer.borderWidth = 1.0f;
    _specialLabel.layer.borderColor = UIColorWithRGBA(230.0f, 109.0f, 81.0f, 1.0f).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)reservationButtonPressed:(UIButton *)sender
{
    // 当[预约]按钮被点击，发送消息通知SCMerchantViewController获取index
    [NOTIFICATION_CENTER postNotificationName:kMerchantDtailReservationNotification object:@(sender.tag)];
}

@end
