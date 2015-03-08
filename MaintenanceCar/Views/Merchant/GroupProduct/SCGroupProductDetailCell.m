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
    _contentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 22.0f;
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
