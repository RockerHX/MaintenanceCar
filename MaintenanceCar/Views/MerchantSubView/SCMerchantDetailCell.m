//
//  SCMerchantDetailCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/18.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMerchantDetailCell.h"
#import <HexColors/HexColor.h>
#import "MicroCommon.h"
#import "SCMerchantFlagCell.h"
#import "SCAllDictionary.h"

@interface SCMerchantDetailCell () <UICollectionViewDataSource>
{
    NSDictionary *_colors;
    NSArray      *_merchantFlags;
}

@end

@implementation SCMerchantDetailCell

#pragma mark - Init Methods
- (void)awakeFromNib
{
    // 绘制圆角
    _reservationButton.layer.cornerRadius = 6.0f;
    
    // 绘制边框和圆角
    _specialLabel.layer.cornerRadius = 2.0f;
    _specialLabel.layer.borderWidth = 1.0f;
    _specialLabel.layer.borderColor = UIColorWithRGBA(230.0f, 109.0f, 81.0f, 1.0f).CGColor;
}

#pragma mark - Action Methods
- (IBAction)reservationButtonPressed:(UIButton *)sender
{
    // 当[预约]按钮被点击，发送消息通知SCMerchantViewController获取index
    [NOTIFICATION_CENTER postNotificationName:kMerchantDtailReservationNotification object:@(sender.tag)];
}

#pragma mark - Public Methods
- (void)hanleMerchantFlags:(NSArray *)merchantFlags
{
    [[SCAllDictionary share] requestColors:^(NSDictionary *colors) {
        _colors        = colors;
        _merchantFlags = merchantFlags;
        [_flagView reloadData];
    }];
}

#pragma mark - Private Methods
- (UIColor *)iconColorWithName:(NSString *)name
{
    NSString *hexString = _colors[name];
    return hexString ? [UIColor colorWithHexString:_colors[name]] : [UIColor blackColor];
}

#pragma mark - Collection View Data Source Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _merchantFlags.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SCMerchantFlagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SCMerchantFlagCell" forIndexPath:indexPath];
    NSString *flag = _merchantFlags[indexPath.row];
    cell.textLabel.text = flag;
    cell.textLabel.backgroundColor = [self iconColorWithName:flag];
    return cell;
}

@end
