//
//  SCOrderDetailPayCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/19.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCOrderDetailPayCell.h"
#import "SCOrderDetail.h"
#import "SCCoupon.h"
#import "MicroConstants.h"

@implementation SCOrderDetailPayCell

#pragma mark - Init Methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    _descriptionLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 128.0f;
}

#pragma mark - Action Methods
- (IBAction)payOrderButtonPressed
{
    if (_delegate && [_delegate respondsToSelector:@selector(userWantToPayForOrder)])
        [_delegate userWantToPayForOrder];
}

#pragma mark - Public Methods
- (void)displayCellWithDetail:(SCOrderDetail *)detail
{
    WEAK_SELF(weakSelf);
    [_descriptionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (detail.isPay)
            make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-8);
        else
            make.right.equalTo(_payOrderButton.mas_left).with.offset(-8);
    }];
    _promptLabel.text = detail.isPay ? @"已支付" : @"预估价格";
    _priceLabel.text = detail.price;
    _descriptionLabel.text = detail.coupon ? [NSString stringWithFormat:@"已使用优惠券：%@（%@）", detail.coupon.title, detail.coupon.prompt] : @"本价格仅供参考，等待商家给出最终价格";
    _payOrderButton.hidden = detail.isPay;
}

@end
