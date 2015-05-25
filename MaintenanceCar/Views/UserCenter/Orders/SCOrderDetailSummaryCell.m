//
//  SCOrderDetailSummaryCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/28.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCOrderDetailSummaryCell.h"

@implementation SCOrderDetailSummaryCell

#pragma mark - Init Methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    _remarkLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 95.0f;
    self.merchantNameLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 122.0f;
}

#pragma mark - Action Methods
- (IBAction)callMerchantButtonPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(shouldCallMerchantWithPhone:)])
        [_delegate shouldCallMerchantWithPhone:_detail.merchantTelphone];
}

#pragma mark - Public Methods
- (void)displayCellWithDetail:(SCOrderDetail *)detail
{
    // 设置订单数据，刷新cell
    _detail = detail;
    
    self.serviceTypeIcon.image  = [UIImage imageNamed:detail.typeImageName];
    self.carModelLabel.text     = detail.carModelName;
    self.serviceNameLabel.text  = detail.serviceName;
    self.merchantNameLabel.text = detail.merchantName;

    _orderDateLabel.text        = detail.orderDate;
    _arriveDateLabel.text       = detail.arriveDate;
    _reserveUserLabel.text      = detail.reserveUser;
    _reservePhoneLabel.text     = detail.reservePhone;
    _remarkLabel.text           = detail.remark;
}

@end
