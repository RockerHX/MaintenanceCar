//
//  SCCarBrandView.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/11.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCarBrandView.h"
#import "MicroCommon.h"
#import "SCCollectionReusableView.h"

@interface SCCarBrandView ()
{
    NSArray *_titles;
}

@end

@implementation SCCarBrandView

#pragma mark - Init Methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _titles = @[@"~", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K"];
    [self performSelector:@selector(initConfig) withObject:nil afterDelay:0.5f];
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
    _collectionView.allowsSelection = NO;
    _collectionView.allowsMultipleSelection = NO;
}

#pragma mark - Collection Data Source Methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 12;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    SCCollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CarBrandCollectionHeaderViewReuseIdentifier" forIndexPath:indexPath];
    }
    reusableview.titleLabel.text = _titles[indexPath.section];
    return reusableview;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CarBrandCellReuseIdentifier" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

@end
