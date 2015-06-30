//
//  SCCarModelFilterView.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/30.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCarModelFilterView.h"
#import "SCFilter.h"
#import "SCCarModelFilterViewCell.h"
#import "UIConstants.h"

static CGFloat LabelHeight = 21.0f;
static CGFloat LineHeight = 1.0f;
static CGFloat VerticalSpace = 8.0f;

@implementation SCCarModelFilterView

#pragma mark - Init Methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
}

#pragma mark - Private Methods
- (void)tap{}

#pragma mark - Public Methods
- (void)show
{
    self.hidden = NO;
    
    _myCarViewheightConstraint.constant = _category.myCarsViewHeight;
    _labelHeightConstraint1.constant = LabelHeight;
    _lineHeightConstraint.constant = LineHeight;
    _labelHeightConstraint2.constant = LabelHeight;
    _verticalSpaceConstraint1.constant = VerticalSpace;
    _verticalSpaceConstraint2.constant = VerticalSpace;
    _verticalSpaceConstraint3.constant = VerticalSpace;
    _verticalSpaceConstraint4.constant = VerticalSpace;
    _verticalSpaceConstraint5.constant = VerticalSpace;
    _verticalSpaceConstraint6.constant = VerticalSpace;
    [self needsUpdateConstraints];
    
    [_myCarView reloadData];
    [_otherCarView reloadData];
}

- (void)hidden
{
    [self packUp];
    [self needsUpdateConstraints];
}

- (void)packUp
{
    self.hidden = YES;
    
    _myCarViewheightConstraint.constant = Zero;
    _labelHeightConstraint1.constant = Zero;
    _lineHeightConstraint.constant = Zero;
    _labelHeightConstraint2.constant = Zero;
    _verticalSpaceConstraint1.constant = Zero;
    _verticalSpaceConstraint2.constant = Zero;
    _verticalSpaceConstraint3.constant = Zero;
    _verticalSpaceConstraint4.constant = Zero;
    _verticalSpaceConstraint5.constant = Zero;
    _verticalSpaceConstraint6.constant = Zero;
}

#pragma mark - Collection View Data Source Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([collectionView isEqual:_myCarView])
        return _category.myCars.count;
    else if ([collectionView isEqual:_otherCarView])
        return _category.otherCars.count;
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SCFilterCategoryItem *item  = nil;
    SCCarModelFilterViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SCCarModelFilterViewCell class]) forIndexPath:indexPath];
    if ([collectionView isEqual:_myCarView])
        item = _category.myCars[indexPath.row];
    else if ([collectionView isEqual:_otherCarView])
        item = _category.otherCars[indexPath.row];
    cell.titleLabel.text = item.title;
    return cell;
}

#pragma mark - Collection View Delegate Methods
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH - 36.0f) / 3, 30.0f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SCFilterCategoryItem *item  = nil;
    if ([collectionView isEqual:_myCarView])
        item = _category.myCars[indexPath.row];
    else if ([collectionView isEqual:_otherCarView])
        item = _category.otherCars[indexPath.row];
    if (_delegate && [_delegate respondsToSelector:@selector(carModelDidSelectedWithParameter:value:)])
    {
        if (_category.program)
            [_delegate carModelDidSelectedWithParameter:_category.program value:item.value];
        else if (item.program)
            [_delegate carModelDidSelectedWithParameter:item.program value:item.value];
    }
}

@end
