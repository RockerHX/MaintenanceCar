//
//  SCOrderCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/20.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCOrderCell.h"
#import "SCVersion.h"
#import "SCStarView.h"

@implementation SCOrderCell

#pragma mark - Init Methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    SCDeviceModelType deviceModel = [SCVersion currentModel];
    _nextStateDateLabel.preferredMaxLayoutWidth = (deviceModel == SCDeviceModelTypeIphone6Plus) ? 120.0f : ((deviceModel == SCDeviceModelTypeIphone6) ? 100.0f : 80.0f);
    self.merchantNameLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 50.0f;
}

#pragma mark - Action Methods
- (IBAction)callMerchantButtonPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(shouldCallMerchantWithPhone:)])
        [_delegate shouldCallMerchantWithPhone:_order.merchantTelphone];
}

- (IBAction)appraiseButtonPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(shouldAppraiseWithOrder:)])
        [_delegate shouldAppraiseWithOrder:_order];
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
- (CGFloat)displayCellWithOrder:(SCOrder *)order index:(NSInteger)index
{
    // 设置订单数据，刷新cell
    _order    = order;
    self.tag = index;
    [self restoreCell];
    
    self.serviceTypeIcon.image   = [UIImage imageNamed:order.typeImageName];
    self.carModelLabel.text      = order.carModelName;
    self.serviceNameLabel.text   = order.serviceName;
    self.merchantNameLabel.text  = order.merchantName;

    _previousStateDateLabel.text = order.previousStateDate;
    _previousStateNameLabel.text = order.previousStateName;
    _currentStateDateLabel.text  = order.currentStateDate;
    _currentStateNameLabel.text  = order.currentStateName;
    _nextStateDateLabel.text     = order.nextStateDate;
    _nextStateNameLabel.text     = order.nextStateName;
    
    // 根据后端给的订单状态的数据来设置状态图标是否显示
    if (order.previousStateDate.length || order.previousStateName.length)
    {
        _previousStateIcon.hidden = NO;
        _previousStateLine.hidden = NO;
    }
    if (order.nextStateDate.length || order.nextStateName.length)
    {
        _nextStateIcon.hidden = NO;
        _nextStateLine.hidden = NO;
    }
    
    BOOL canComment = order.canComment;
    if (!canComment)
    {
        if ([order.star length])
        {
            [self showStar];
            _starView.value = order.star;
        }
        else
            [self hidComment];
    }
    else
        [self showComment];
    
    return [self layoutSizeFittingSize];
}

@end
