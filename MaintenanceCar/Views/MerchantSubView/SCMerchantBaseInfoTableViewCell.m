//
//  SCMerchantBaseInfoTableViewCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/4.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMerchantBaseInfoTableViewCell.h"
#import "MicroCommon.h"

@implementation SCMerchantBaseInfoTableViewCell

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)reservationButtonPressed:(UIButton *)sender
{
}

@end
