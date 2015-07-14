//
//  SCCarModelFilterView.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/30.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCarModelFilterView.h"
#import "UIConstants.h"
#import "AppMicroConstants.h"
#import "SCFilter.h"
#import "SCCarModelFilterReusableView.h"
#import "SCCarModelFilterViewCell.h"

@implementation SCCarModelFilterView

#pragma mark - Init Methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self viewConfig];
}

#pragma mark - Config Methods
- (void)viewConfig
{
    _collectionView.scrollsToTop = NO;
}

#pragma mark - Public Methods
- (void)setCategory:(SCCarModelFilterCategory *)category
{
    _category = category;
    if (category.myCars.count)
        _indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    else
        _indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
}

#pragma mark - Public Methods
- (void)show
{
    self.hidden = NO;
    [_collectionView reloadData];
}

- (void)hidden
{
    self.hidden = YES;
}

#pragma mark - Collection View Data Source Methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger itemCount = Zero;
    switch (section)
    {
        case 0:
            itemCount = _category.myCars.count;
            break;
        case 1:
            itemCount = _category.otherCars.count;
            break;
    }
    return itemCount;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    SCCarModelFilterReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader)
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([SCCarModelFilterReusableView class]) forIndexPath:indexPath];
    reusableView.titleLabel.text = indexPath.section ? @"其他品牌" : @"可接受我的车辆的";
    reusableView.line.hidden = !indexPath.section;
    return reusableView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SCFilterCategoryItem *item  = nil;
    SCCarModelFilterViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SCCarModelFilterViewCell class]) forIndexPath:indexPath];
    cell.backgroundColor = ((indexPath.section == _indexPath.section) && (indexPath.row == _indexPath.row)) ? ThemeColor : [UIColor lightGrayColor];
    switch (indexPath.section)
    {
        case 0:
            item = _category.myCars[indexPath.row];
            break;
        case 1:
            item = _category.otherCars[indexPath.row];
            break;
    }
    cell.titleLabel.text = item.title;
    return cell;
}

#pragma mark - Collection View Delegate Methods
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(((SCREEN_WIDTH - 60.0f) / 3), 30.0f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    [collectionView reloadData];
    
    SCFilterCategoryItem *item  = nil;
    switch (indexPath.section)
    {
        case 0:
            item = _category.myCars[indexPath.row];
            break;
        case 1:
            item = _category.otherCars[indexPath.row];
            break;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(selectedCompletedWithTitle:parameter:value:)])
    {
        if (_category.program)
            [_delegate selectedCompletedWithTitle:@"车型" parameter:_category.program value:item.value];
        else if (item.program)
            [_delegate selectedCompletedWithTitle:@"车型" parameter:item.program value:item.value];
    }
}

@end
