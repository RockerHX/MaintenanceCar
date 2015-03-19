//
//  SCGroupProductMerchantCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/8.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCGroupProductMerchantCell.h"
#import "MicroCommon.h"
#import "SCStarView.h"
#import "SCGroupProductDetail.h"

@implementation SCGroupProductMerchantCell

#pragma mark - Init Methods
- (void)awakeFromNib
{
    // Initialization code
    CGFloat layoutWidth = SCREEN_WIDTH - 71.0f;
    _nameLabel.preferredMaxLayoutWidth = layoutWidth;
    _addressLabel.preferredMaxLayoutWidth = layoutWidth;
}

#pragma mark - Action Methods
- (IBAction)callButtonPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(shouldCallMerchant)])
        [_delegate shouldCallMerchant];
}

#pragma mark - Public Methods
- (void)displayCellWithDetial:(SCGroupProductDetail *)detail
{
    _nameLabel.text = detail.merchantName;
    //    _starView.startValue = detail;
    //    _distanceLabel.text = detail;
    //    _addressLabel.text = detail;
    _starView.value = @"4";
    _distanceLabel.text = @"123";
    _addressLabel.text = @"123\nsadfsdfsdfsdfasdfsadfawerwqerwqerqwerwqersadfasfweqrwsersafsadfsdaczxcvasdfdasfdsdafasf\nsafdasdfsadfsadfsadfasdfasdfsadf\nasdfasdfasdf";
}

@end
