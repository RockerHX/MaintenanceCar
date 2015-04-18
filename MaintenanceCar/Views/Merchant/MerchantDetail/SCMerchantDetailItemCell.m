//
//  SCMerchantDetailItemCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/5.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMerchantDetailItemCell.h"
#import "UIConstants.h"
#import "MicroConstants.h"
#import "SCMerchantInfo.h"

@implementation SCMerchantDetailItemCell

#pragma mark - Init Methods
- (void)awakeFromNib
{
    // Initialization code
    _contentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 52.0f;
}

#pragma mark - Public Methods
- (void)displayCellWithItem:(SCMerchantInfoItem *)infoItem
{
    _icon.image             = [UIImage imageNamed:infoItem.imageName];
    _contentLabel.text      = infoItem.text;
    _contentLabel.font      = [UIFont systemFontOfSize:infoItem.fontSize];
    _contentLabel.textColor = infoItem.textColor;
    self.accessoryType      = infoItem.accessoryType;
    self.selected           = infoItem.canSelected;

    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
}

@end
