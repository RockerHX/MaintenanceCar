//
//  SCCarBrandView.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/11.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCarBrandView.h"
#import "MicroCommon.h"
#import "API.h"
#import "SCAPIRequest.h"
#import "SCCollectionReusableView.h"
#import "SCCarBrandCollectionViewCell.h"
#import "SCCarBrand.h"

@interface SCCarBrandView ()

@end

@implementation SCCarBrandView

#pragma mark - Init Methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // 延时初始化相关数据，以便View正常显示
    [self performSelector:@selector(initConfig) withObject:nil afterDelay:0.5f];
}

#pragma mark - Action Methods
- (void)titleColumnTaped
{
    if (self.canSelected && [_delegate respondsToSelector:@selector(carBrandViewTitleTaped)])
        [_delegate carBrandViewTitleTaped];
}

#pragma mark - Private Methods
- (void)initConfig
{
    // 初始化的时候更改约束条件达到正确的显示效果
    self.topHeightConstraint.constant = SCREEN_HEIGHT - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - 44.0f;
    [_collectionView needsUpdateConstraints];
    [_collectionView layoutIfNeeded];
}

- (void)viewConfig
{
}

#pragma mark - Collection Data Source Methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _indexTitles.count;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    // 车辆品牌分栏标题栏数据刷新
    SCCollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CarBrandCollectionHeaderViewReuseIdentifier" forIndexPath:indexPath];
    }
    NSString *title = _indexTitles[indexPath.section];
    reusableview.titleLabel.text = [title isEqualToString:@"0"] ? @"推荐" : title;
    return reusableview;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return ((NSArray *)_carBrands[_indexTitles[section]]).count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 汽车品牌项数据刷新
    SCCarBrandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CarBrandCellReuseIdentifier" forIndexPath:indexPath];
    
    // Configure the cell...
    SCCarBrand *carBrand = ((NSArray *)_carBrands[_indexTitles[indexPath.section]])[indexPath.row];
    [cell.carIcon setImageWithURL:[ImageURL stringByAppendingString:carBrand.img_name] defaultImage:@"DefaultCarBrand"];
    cell.carTitleLabel.text = carBrand.brand_name;
    
    return cell;
}

#pragma mark - Collection Delegate Methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 某一个车辆品牌被选中之后获取数据，通知回调进行车辆车型数据显示
    SCCarBrand *carBrand = ((NSArray *)_carBrands[_indexTitles[indexPath.section]])[indexPath.row];
    _carBrandLabel.text = carBrand.brand_name;
    
    if ([_delegate respondsToSelector:@selector(carBrandViewDidSelectedCar:)])
        [_delegate carBrandViewDidSelectedCar:carBrand];
}

#pragma mark - Scroll View Delegate Methods
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 当前View滚动结束通知代理方法显示提示
    if ([_delegate respondsToSelector:@selector(carBrandViewScrollEnd)])
        [_delegate carBrandViewScrollEnd];
}

#pragma mark - Public Methods
- (void)refresh
{
    // 手动刷新车辆品牌数据
    [_collectionView reloadData];
}

@end
