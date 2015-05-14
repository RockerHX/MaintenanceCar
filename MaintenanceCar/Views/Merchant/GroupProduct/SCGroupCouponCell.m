//
//  SCGroupCouponCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCGroupCouponCell.h"
#import "SCGroupCoupon.h"

@implementation SCGroupCouponCell

#pragma mark - Public Methods
- (void)displayCellWithCoupon:(SCGroupCoupon *)coupon index:(NSInteger)index
{
    [super displayCellWithCoupon:coupon index:index];
    
    _productNameLabel.text  = [coupon.title stringByAppendingString:@":"];
    _merchantNameLabel.text = coupon.company_name;
    _couponPriceLabel.text  = coupon.final_price;
    _productPriceLabel.text = coupon.total_price;
    _couponStateLabel.text  = [self codeStateWithCoupon:coupon.state];
    
    _codeLine.hidden = (coupon.state == SCGroupCouponStateUnUse);
    self.codeLabel.textColor = (coupon.state == SCGroupCouponStateUnUse) ? [UIColor orangeColor] : [UIColor lightGrayColor];
}

#pragma mark - Private Methods
- (NSString *)codeStateWithCoupon:(SCGroupCouponState)state
{
    NSString *codeState;
    switch (state)
    {
        case SCGroupCouponStateUnUse:
            codeState = @"未使用";
            break;
        case SCGroupCouponStateUsed:
            codeState = @"已使用";
            break;
        case SCGroupCouponStateCancel:
            codeState = @"已取消";
            break;
        case SCGroupCouponStateExpired:
            codeState = @"已过期";
            break;
        case SCGroupCouponStateRefunding:
            codeState = @"退款中";
            break;
        case SCGroupCouponStateRefunded:
            codeState = @"已退款";
            break;
        case SCGroupCouponStateReserved:
            codeState = @"已预约";
            break;
            
        default:
            codeState = @"-";
            break;
    }
    return codeState;
}

@end
