//
//  SCCarBrandView.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/11.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCarBrandView.h"
#import "MicroCommon.h"

@implementation SCCarBrandView

#pragma mark - Init Methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    
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
}

#pragma mark - Collection Data Source Methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CarBrandCellReuseIdentifier" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

@end
