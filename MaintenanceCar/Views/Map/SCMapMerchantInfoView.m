//
//  SCMapMerchantDetailView.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/7.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMapMerchantInfoView.h"
#import <HexColors/HexColor.h>
#import "MicroCommon.h"
#import "SCAPIRequest.h"
#import "SCStarView.h"
#import "SCMerchant.h"
#import "SCMerchantFlagCell.h"
#import "SCAllDictionary.h"
#import "API.h"

@interface SCMapMerchantInfoView () <UICollectionViewDataSource>
{
    NSDictionary *_colors;
    NSArray      *_merchantFlags;
}

@end

@implementation SCMapMerchantInfoView

#pragma mark - Init Methods
- (void)awakeFromNib
{
    [self initConfig];
}

#pragma mark - Private Methods
- (void)initConfig
{
    _flagView.dataSource = self;
    // 绘制边框和圆角
    _specialLabel.layer.cornerRadius = 2.0f;
    _specialLabel.layer.borderWidth = 1.0f;
    _specialLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    // 添加点击手势
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer)]];
}

- (void)tapGestureRecognizer
{
    if ([_delegate respondsToSelector:@selector(shouldShowMerchantDetail)])
        [_delegate shouldShowMerchantDetail];
}

- (UIColor *)iconColorWithName:(NSString *)name
{
    NSString *hexString = _colors[name];
    return hexString ? [UIColor colorWithHexString:_colors[name]] : [UIColor clearColor];
}

#pragma mark - Public Methods
- (void)handelWithMerchant:(SCMerchant *)merchant
{
    [_merchantIcon setImageWithURL:[NSString stringWithFormat:@"%@%@_s.jpg", MerchantImageDoMain, merchant.company_id] defaultImage:@"MerchantIconDefault"];
    
    _merchantNameLabel.text = merchant.name;
    _distanceLabel.text     = merchant.distance;
    _starView.startValue    = merchant.star;
    
    if (merchant.tags.length)
    {
        _specialLabel.hidden = NO;
        _specialLabel.text   = merchant.tags;
    }
    else
        _specialLabel.hidden = YES;
    
    [[SCAllDictionary share] requestColorsExplain:^(NSDictionary *colors, NSDictionary *explain, NSDictionary *detail) {
        _colors        = colors;
        _merchantFlags = merchant.merchantFlags;
        
        _flagViewWidthConstraint.constant = _merchantFlags.count * 16.0f;
        [_flagView needsUpdateConstraints];
        [_flagView layoutIfNeeded];
        [_flagView reloadData];
    }];
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
