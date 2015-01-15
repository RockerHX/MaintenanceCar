//
//  SCCarBrandView.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/11.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCarBrandView.h"
#import <UIImageView+AFNetworking.h>
#import "MicroCommon.h"
#import "API.h"
#import "SCCollectionReusableView.h"
#import "SCCarBrandCollectionViewCell.h"
#import "SCCarBrand.h"

@implementation SCCarBrandView

#pragma mark - Init Methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self performSelector:@selector(initConfig) withObject:nil afterDelay:0.5f];
    [self.titleView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleColumnTaped)]];
}

#pragma mark - Action Methods
- (void)titleColumnTaped
{
    if (self.canSelected)
    {
        [_delegate carBrandViewTitleTaped];
    }
}

#pragma mark - Private Methods
- (void)initConfig
{
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
    SCCollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CarBrandCollectionHeaderViewReuseIdentifier" forIndexPath:indexPath];
    }
    reusableview.titleLabel.text = _indexTitles[indexPath.section];
    return reusableview;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return ((NSArray *)_carBrands[_indexTitles[section]]).count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SCCarBrandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CarBrandCellReuseIdentifier" forIndexPath:indexPath];
    
    // Configure the cell...
    SCCarBrand *carBrand = ((NSArray *)_carBrands[_indexTitles[indexPath.section]])[indexPath.row];
    [cell.carIcon setImageWithURL:[NSURL URLWithString:[ImageURL stringByAppendingString:carBrand.img_name]]];
    cell.carTitleLabel.text = carBrand.brand_name;
    
    return cell;
}

#pragma mark - Collection Delegate Methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SCCarBrand *carBrand = ((NSArray *)_carBrands[_indexTitles[indexPath.section]])[indexPath.row];
    [_delegate carBrandViewDidSelectedCar:carBrand];
}

#pragma mark - Scroll View Delegate Methods
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [_delegate carBrandViewScrollEnd];
}

#pragma mark - Public Methods
- (void)refresh
{
    [_collectionView reloadData];
}

@end
