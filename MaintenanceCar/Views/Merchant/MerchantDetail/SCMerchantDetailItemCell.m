//
//  SCMerchantDetailItemCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/5.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMerchantDetailItemCell.h"
#import "MicroCommon.h"
#import "SCMerchantDetail.h"

@implementation SCMerchantDetailItemCell

#pragma mark - Init Methods
- (void)awakeFromNib
{
    // Initialization code
    _contentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 52.0f;
}

#pragma mark - Public Methods
- (void)displayCellWithIndex:(NSIndexPath *)indexPath detail:(SCMerchantDetail *)detail
{
    NSString *image        = nil;
    NSString *text         = nil;
    CGFloat  fontSize      = 15.0f;
    UIColor  *textColor    = [UIColor blackColor];
    BOOL     showAccessory = NO;
    BOOL     canSelected   = NO;
    switch (indexPath.row)
    {
        case 0:
        {
            image         = @"MerchantAddressIcon";
            text          = detail.address;
            showAccessory = YES;
            canSelected   = YES;
        }
            break;
        case 1:
        {
            image     = @"MerchantPhoneIcon";
            text      = detail.telephone;
            textColor = UIColorWithRGBA(70.0f, 171.0f, 218, 1.0f);
            canSelected   = YES;
        }
            break;
        case 2:
        {
            image = @"merchantTimeIcon";
            text  = [NSString stringWithFormat:@"%@ - %@", [detail.time_open substringWithRange:(NSRange){0, 5}], [detail.time_closed substringWithRange:(NSRange){0, 5}]];
        }
            break;
    }
    _icon.image = [UIImage imageNamed:image];
    _contentLabel.text = text.length ? text : @"数据完善中...";
    _contentLabel.font = [UIFont systemFontOfSize:fontSize];
    _contentLabel.textColor = textColor;
    self.accessoryType = showAccessory ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    self.selected = canSelected;
    
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
}

@end
