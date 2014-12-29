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

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)reservationButtonPressed:(UIButton *)sender
{
    // 当[预约]按钮被点击，发送消息通知SCMerchantViewController获取index
    [NS_NOTIFICATION_CENTER postNotificationName:kMerchantListReservationNotification object:@(sender.tag)];
}

@end
