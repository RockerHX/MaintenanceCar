//
//  SCMyOderCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/20.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMyOderCell.h"

@implementation SCMyOderCell
{
    SCMyOder *_oder;
}

#pragma mark - Init Methods
- (void)awakeFromNib
{
    // 设置商家名称栏预算宽度，以便计算整个cell的动态高度
    _merchantNameLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 40.0f;
}

#pragma mark - Action Methods
- (IBAction)callMerchantButtonPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(shouldCallMerchantWithPhone:)])
        [_delegate shouldCallMerchantWithPhone:_oder.merchantTelphone];
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

#pragma mark - Public Methods
- (CGFloat)displayCellWithReservation:(SCMyOder *)oder index:(NSInteger)index
{
    // 设置订单数据，刷新cell
    _oder = oder;
    self.tag = index;
    [self restoreCell];
    
    _serviceTypeIcon.image = [UIImage imageNamed:oder.typeImageName];
    _carModelLabel.text = oder.carModelName;
    _serviceNameLabel.text = oder.serviceName;
    _merchantNameLabel.text = oder.merchantName;
    
    _previousStateDateLabel.text = oder.previousStateDate;
    _previousStateNameLabel.text = oder.previousStateName;
    _currentStateDateLabel.text  = oder.currentStateDate;
    _currentStateNameLabel.text  = oder.currentStateName;
    _nextStateDateLabel.text     = oder.nextStateDate;
    _nextStateNameLabel.text     = oder.nextStateName;
    
    // 根据后端给的订单状态的数据来设置状态图标是否显示
    if (oder.previousStateDate && oder.previousStateName)
    {
        _previousStateIcon.hidden = NO;
        _previousStateLine.hidden = NO;
    }
    if (oder.nextStateDate && oder.nextStateName)
    {
        _nextStateIcon.hidden = NO;
        _nextStateLine.hidden = NO;
    }
    
    return [self layoutSizeFittingSize];
}

@end
