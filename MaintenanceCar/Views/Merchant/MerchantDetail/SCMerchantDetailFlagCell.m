//
//  SCMerchantDetailFlagCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/14.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMerchantDetailFlagCell.h"
#import <HexColors/HexColor.h>
#import "UIConstants.h"
#import "SCMerchantSummary.h"

@implementation SCMerchantDetailFlagCell
{
    NSString *_content;
}

#pragma mark - Init Methods
- (void)awakeFromNib
{
    [self initConfig];
    self.separatorInset = UIEdgeInsetsMake(ZERO_POINT, ZERO_POINT, ZERO_POINT, SCREEN_WIDTH - 16.0f);
    // 绘制圆角
    _flagBgView.layer.cornerRadius = 4.0f;
    _flagBgView.layer.borderWidth  = 1.0f;
}

#pragma mark - Config Methods
- (void)initConfig
{
    [_flagBgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer)]];
}

#pragma mark - Private Methods
- (void)tapGestureRecognizer
{
    if (_delegate && [_delegate respondsToSelector:@selector(flagPressedWithMessage:)])
        [_delegate flagPressedWithMessage:_content];
}

#pragma mark - Public Methods
- (void)displayCellWithMerchangFlag:(SCMerchantFlag *)flag
{
    _flagIcon.image   = [UIImage imageNamed:flag.imageName];
    _titleLabel.text  = flag.title;
    _promptLabel.text = flag.prompt;
    _content          = flag.content;
    
    _flagBgView.layer.borderColor  = [UIColor colorWithHexString:flag.colorHex].CGColor;
}

@end
