//
//  SCMerchantCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/30.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMerchantCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <HexColors/HexColor.h>
#import "MicroConstants.h"
#import "SCAPIRequest.h"
#import "SCStarView.h"
#import "SCMerchantFlagCell.h"
#import "SCAllDictionary.h"
#import "API.h"

@interface SCMerchantCell () <UICollectionViewDataSource>
{
    NSDictionary *_colors;
    NSArray      *_merchantFlags;
}

@end

@implementation SCMerchantCell

#pragma mark - Init Methods
- (void)awakeFromNib
{
    [self initConfig];
}

#pragma mark - Private Methods
- (void)initConfig
{
    _flagView.dataSource = self;
    // 圆角和颜色处理
    _specialLabel.layer.cornerRadius = 2.0f;
    _specialLabel.layer.borderWidth  = 1.0f;
    _specialLabel.layer.borderColor  = UIColorWithRGBA(230.0f, 109.0f, 81.0f, 1.0f).CGColor;
}

- (UIColor *)iconColorWithName:(NSString *)name
{
    NSString *hexString = _colors[name];
    return hexString ? [UIColor colorWithHexString:_colors[name]] : [UIColor clearColor];
}

#pragma mark - Public Methods
- (void)handelWithMerchant:(SCMerchant *)merchant
{
    [_merchantIcon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@_s.jpg", MerchantImageDoMain, merchant.company_id]]
                  placeholderImage:[UIImage imageNamed:@"MerchantIconDefault"]];
    _merchantNameLabel.text = merchant.name;
    _distanceLabel.text     = merchant.distance;
    _starView.value         = merchant.star;
    
//    if (merchant.tags.length)
//    {
//        _specialLabel.hidden = NO;
//        _specialLabel.text   = merchant.tags;
//    }
//    else
        _specialLabel.hidden = YES;
    _merchantFlags = merchant.merchantFlags;
    
    _flagViewWidthConstraint.constant = _merchantFlags.count * 19.0f;
    [_flagView needsUpdateConstraints];
    [_flagView layoutIfNeeded];
    [_flagView reloadData];
}

#pragma mark - Collection View Data Source Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _merchantFlags.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SCMerchantFlagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SCMerchantFlagCell" forIndexPath:indexPath];
    cell.icon.image = [UIImage imageNamed:[[SCAllDictionary share] imageNameOfFlag:_merchantFlags[indexPath.row]]];
    return cell;
}

@end
