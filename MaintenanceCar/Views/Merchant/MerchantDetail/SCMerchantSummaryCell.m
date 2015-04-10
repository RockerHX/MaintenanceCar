//
//  SCMerchantSummaryCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/18.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMerchantSummaryCell.h"
#import <HexColors/HexColor.h>
#import "VersionConstants.h"
#import "UIConstants.h"
#import "SCMerchantDetailFlagCell.h"
#import "SCAllDictionary.h"
#import "SCStarView.h"

@interface SCMerchantSummaryCell () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSString     *_majors;
    NSDictionary *_colors;
    NSDictionary *_explains;
    NSDictionary *_details;
    NSArray      *_merchantFlags;
}

@end

@implementation SCMerchantSummaryCell

#pragma mark - Init Methods
- (void)awakeFromNib
{
    // 绘制圆角
    _reservationButton.layer.cornerRadius = 6.0f;
    _merchantNameLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 23.0f;
}

#pragma mark - Action Methods
- (IBAction)reservationButtonPressed:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(shouldReservation)])
        [_delegate shouldReservation];
}

#pragma mark - Public Methods
- (void)hanleMerchantFlags:(NSArray *)merchantFlags
{
    [[SCAllDictionary share] requestColorsExplain:^(NSDictionary *colors, NSDictionary *explain, NSDictionary *detail) {
        _colors        = colors;
        _explains      = explain;
        _details       = detail;
        _merchantFlags = merchantFlags;
        [_flagView reloadData];
    }];
}

- (void)displayCellWithSummary:(SCMerchantSummary *)detailSummary
{
    _merchantNameLabel.text   = detailSummary.name;
    _majors                   = detailSummary.majors;
    _distanceLabel.text       = detailSummary.distance;
    _starView.value           = detailSummary.star;
    _reservationButton.hidden = detailSummary.unReserve;
    [self hanleMerchantFlags:detailSummary.flags];
    
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
}

#pragma mark - Private Methods
- (UIColor *)colorWithName:(NSString *)name
{
    NSString *hexString = _colors[name];
    return hexString ? [UIColor colorWithHexString:_colors[name]] : [UIColor blackColor];
}

- (NSString *)explainWithName:(NSString *)name
{
    NSString *hexString = _explains[name];
    return hexString ? hexString : @"";
}
- (NSString *)detailWithName:(NSString *)name
{
    NSString *hexString = _details[name];
    if ([name hasPrefix:@"专"])
    {
        if (_majors)
            hexString = [hexString stringByAppendingString:[NSString stringWithFormat:@"(%@)", _majors]];
    }
    return hexString ? hexString : @"";
}

#pragma mark - Collection View Data Source Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _merchantFlags.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SCMerchantDetailFlagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SCMerchantDetailFlagCell" forIndexPath:indexPath];
    NSString *flag = _merchantFlags[indexPath.row];
    cell.flagLabel.text = flag;
    cell.textLabel.text = [self explainWithName:flag];
    cell.color = [self colorWithName:flag];
    return cell;
}

#pragma mark - Collection View Delegate Methods
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (IS_IPHONE_6)
        return 20.0f;
    if (IS_IPHONE_6Plus)
        return 30.0f;
    else
        return 10.0f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[self explainWithName:_merchantFlags[indexPath.row]]
                                                        message:[self detailWithName:_merchantFlags[indexPath.row]]
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

@end
