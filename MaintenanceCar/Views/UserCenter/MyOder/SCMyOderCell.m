//
//  SCMyOderCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/20.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMyOderCell.h"
#import "VersionConstants.h"
#import "SCStarView.h"

@implementation SCMyOderCell

#pragma mark - Init Methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    _nextStateDateLabel.preferredMaxLayoutWidth = IS_IPHONE_6Plus ? 120.0f : (IS_IPHONE_6 ? 100.0f : 80.0f);
}

#pragma mark - Action Methods
- (IBAction)callMerchantButtonPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(shouldCallMerchantWithPhone:)])
        [_delegate shouldCallMerchantWithPhone:_oder.merchantTelphone];
}

- (IBAction)appraiseButtonPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(shouldAppraiseWithOder:)])
        [_delegate shouldAppraiseWithOder:_oder];
}

#pragma mark - Private Methods
- (void)restoreCell
{
    // 重置订单的上下状态图标隐藏状态
    _previousStateIcon.hidden = YES;
    _previousStateLine.hidden = YES;
    _nextStateLine.hidden     = YES;
    _nextStateIcon.hidden     = YES;
}

#pragma mark - Private Methods
- (void)showComment
{
    _starPromptLabel.hidden            = YES;
    _starView.hidden                   = YES;
    _appraiseButton.hidden             = NO;
    _starPromptLabelTopHeight.constant = ZERO_POINT;
    _starPromptLabelHeight.constant    = ZERO_POINT;
}

- (void)hidComment
{
    [self showComment];
    _appraiseButton.hidden             = YES;
}

- (void)showStar
{
    _starPromptLabel.hidden            = NO;
    _starView.hidden                   = NO;
    _appraiseButton.hidden             = YES;
    _starPromptLabelTopHeight.constant = 20.0f;
    _starPromptLabelHeight.constant    = 21.0f;
}

#pragma mark - Public Methods
- (CGFloat)displayCellWithOder:(SCMyOder *)oder index:(NSInteger)index
{
    // 设置订单数据，刷新cell
    _oder    = oder;
    self.tag = index;
    [self restoreCell];
    
    self.serviceTypeIcon.image   = [UIImage imageNamed:oder.typeImageName];
    self.carModelLabel.text      = oder.carModelName;
    self.serviceNameLabel.text   = oder.serviceName;
    self.merchantNameLabel.text  = oder.merchantName;

    _previousStateDateLabel.text = oder.previousStateDate;
    _previousStateNameLabel.text = oder.previousStateName;
    _currentStateDateLabel.text  = oder.currentStateDate;
    _currentStateNameLabel.text  = oder.currentStateName;
    _nextStateDateLabel.text     = oder.nextStateDate;
    _nextStateNameLabel.text     = oder.nextStateName;
    
    // 根据后端给的订单状态的数据来设置状态图标是否显示
    if (oder.previousStateDate.length || oder.previousStateName.length)
    {
        _previousStateIcon.hidden = NO;
        _previousStateLine.hidden = NO;
    }
    if (oder.nextStateDate.length || oder.nextStateName.length)
    {
        _nextStateIcon.hidden = NO;
        _nextStateLine.hidden = NO;
    }
    
    BOOL canComment = oder.canComment;
    if (!canComment)
    {
        if ([oder.star length])
        {
            [self showStar];
            _starView.value = oder.star;
        }
        else
            [self hidComment];
    }
    else
        [self showComment];
    
    return [self layoutSizeFittingSize];
}

@end
