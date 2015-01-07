//
//  SCMapMerchantDetailView.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/7.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMapMerchantInfoView.h"
#import "MicroCommon.h"

@implementation SCMapMerchantInfoView

- (void)awakeFromNib
{
    // Initialization code
    
    // 绘制圆角
    _merchantIcon.layer.cornerRadius = 3.0f;
    _reservationButton.layer.cornerRadius = 6.0f;
    
    // 绘制边框和圆角
    _specialLabel.layer.cornerRadius = 2.0f;
    _specialLabel.layer.borderWidth = 1.0f;
    _specialLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

@end
