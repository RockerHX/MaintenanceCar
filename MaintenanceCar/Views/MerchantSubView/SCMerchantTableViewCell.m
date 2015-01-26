//
//  SCMerchantTableViewCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/26.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCMerchantTableViewCell.h"
#import <HexColors/HexColor.h>
#import "MicroCommon.h"
#import "SCStarView.h"
#import "SCMerchant.h"

@implementation SCMerchantTableViewCell

#pragma mark - Init Methods
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

#pragma mark - Action Methods
- (IBAction)reservationButtonPressed:(UIButton *)sender
{
    // 当[预约]按钮被点击，发送消息通知SCMerchantViewController获取index
    [NOTIFICATION_CENTER postNotificationName:kMaintenanceReservationNotification object:@(sender.tag)];
}

#pragma mark - Private Methods
- (void)viewConfig
{
    _buttonWidth.constant = 66.0f;
    [_reservationButton needsUpdateConstraints];
    [UIView animateWithDuration:0.3f animations:^{
        [_reservationButton layoutIfNeeded];
    }];
}

- (void)hanleSamllIconWithMerchant:(SCMerchant *)merchant
{
    if (merchant.zige)
    {
        _zigeLable.text                 = merchant.zige;
        _zigeLable.backgroundColor      = [self iconColorWithName:merchant.zige];
    }
    else
        _zigeLable.hidden = YES;
    
    if (merchant.honest)
    {
        _honestLabel.text               = merchant.honest;
        _honestLabel.backgroundColor    = [self iconColorWithName:merchant.honest];
    }
    else
        _honestLabel.hidden = YES;
    
    if (merchant.major_type)
    {
        _majorTypeLabel.text            = merchant.major_type;
        _majorTypeLabel.backgroundColor = [self iconColorWithName:merchant.major_type];
    }
    else
        _majorTypeLabel.hidden = YES;
}

- (UIColor *)iconColorWithName:(NSString *)name
{
    NSString *hexString = _colors[name];
    return hexString ? [UIColor colorWithHexString:_colors[name]] : [UIColor clearColor];
}

#pragma mark - Public Methods
- (void)handelWithMerchant:(SCMerchant *)merchant indexPath:(NSIndexPath *)indexPath
{
    _merchantNameLabel.text = merchant.name;
    _distanceLabel.text     = merchant.distance;
    _starView.startValue    = merchant.star;
    _specialLabel.text      = merchant.tags.length ? merchant.tags : @"价格实惠";
    _reservationButton.tag  = indexPath.row;
    [self hanleSamllIconWithMerchant:merchant];
}

@end
