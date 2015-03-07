//
//  SCGroupProductMerchantCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/8.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCGroupProductMerchantCell.h"
#import "SCGroupProductDetail.h"
#import "SCStarView.h"
#import "MicroCommon.h"

@implementation SCGroupProductMerchantCell

#pragma mark - Init Methods
- (void)awakeFromNib
{
    // Initialization code
    CGFloat layoutWidth = DOT_COORDINATE;
    if (IS_IPHONE_6Plus)
        layoutWidth = 329.0f;
    else if (IS_IPHONE_6)
        layoutWidth = 304.0f;
    else
        layoutWidth = 249.0f;
    _nameLabel.preferredMaxLayoutWidth = layoutWidth;
    _addressLabel.preferredMaxLayoutWidth = layoutWidth;
}

#pragma mark - Action Methods
- (IBAction)callButtonPressed:(id)sender
{
    if ([_delegate respondsToSelector:@selector(shouldCallMerchant)])
        [_delegate shouldCallMerchant];
}

#pragma mark - Public Methods
- (void)displayCellWithDetial:(SCGroupProductDetail *)detail
{
    _nameLabel.text = detail.merchantName;
//    _starView.startValue = detail;
//    _distanceLabel.text = detail;
//    _addressLabel.text = detail;
    _starView.startValue = @"4";
    _distanceLabel.text = @"123";
    _addressLabel.text = @"123";
}

@end
