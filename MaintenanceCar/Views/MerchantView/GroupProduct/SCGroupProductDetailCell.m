//
//  SCGroupProductDetailCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/8.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCGroupProductDetailCell.h"
#import "SCGroupProductDetail.h"
#import "MicroCommon.h"

@implementation SCGroupProductDetailCell

#pragma mark - Init Methods
- (void)awakeFromNib
{
    // Initialization code
    CGFloat layoutWidth = DOT_COORDINATE;
    if (IS_IPHONE_6Plus)
        layoutWidth = 378.0f;
    else if (IS_IPHONE_6)
        layoutWidth = 353.0f;
    else
        layoutWidth = 398.0f;
    _contentLabel.preferredMaxLayoutWidth = layoutWidth;
}

#pragma mark - Public Methods
- (void)displayCellWithDetail:(SCGroupProductDetail *)detail
{
    _contentLabel.text = @"";
    NSUInteger count = detail.des.count;
    [detail.des enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        _contentLabel.text = [NSString stringWithFormat:@"%@%@%@", _contentLabel.text, obj, (idx == (count - 1)) ? @"" : @"\n"];
    }];
}

@end
