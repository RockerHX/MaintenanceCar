//
//  SCCouponHeaderView.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCouponHeaderView.h"
#import "MicroCommon.h"
#import "SCCoupon.h"

@implementation SCCouponHeaderView

#pragma mark - Init Methods
- (id)init
{
    // 从Xib加载View
    self = [[[NSBundle mainBundle] loadNibNamed:@"SCCouponCell" owner:self options:nil] firstObject];
    self.frame = CGRectMake(DOT_COORDINATE, DOT_COORDINATE, SCREEN_WIDTH, 120.0f);
    return self;
}

#pragma mark - Public Methods
- (void)displayHeaderWithCoupon:(SCCoupon *)coupon
{
    
}

@end
