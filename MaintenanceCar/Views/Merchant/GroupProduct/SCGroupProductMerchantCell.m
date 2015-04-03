//
//  SCGroupProductMerchantCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/8.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCGroupProductMerchantCell.h"
#import "UIConstants.h"
#import "SCStarView.h"
#import "SCGroupProductDetail.h"

@implementation SCGroupProductMerchantCell

#pragma mark - Init Methods
- (void)awakeFromNib
{
    // Initialization code
    CGFloat layoutWidth = SCREEN_WIDTH - 70.0f;
    _nameLabel.preferredMaxLayoutWidth = layoutWidth;
    _addressLabel.preferredMaxLayoutWidth = layoutWidth;
}

#pragma mark - Action Methods
- (IBAction)callButtonPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(shouldCallToMerchant)])
        [_delegate shouldCallToMerchant];
}

#pragma mark - Public Methods
- (void)displayCellWithDetial:(SCGroupProductDetail *)detail
{
    _nameLabel.text = detail.merchantName;
    _starView.value = [@([detail.star integerValue]/2) stringValue];
    _distanceLabel.text = detail.distance;
    _addressLabel.text = detail.address;
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
}

@end
