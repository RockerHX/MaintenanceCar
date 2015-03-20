//
//  SCMerchantServiceCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/21.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMerchantServiceCell.h"
#import "SCMerchantDetail.h"
#import "MicroCommon.h"

@implementation SCMerchantServiceCell
{
    NSDictionary *_serviceItems;
}

- (void)awakeFromNib
{
}

#pragma mark - Public Methods
- (void)displayCellWithDetail:(SCMerchantDetail *)detail
{
    _serviceItems = detail.serviceItems;
    
    [_serviceView reloadData];
}

#pragma mark - Collection View Data Source Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[_serviceItems allKeys] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SCServiceItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SCServiceItemCell" forIndexPath:indexPath];
    cell.delegate = self;
    [cell displayCellWithDate:@{[_serviceItems allKeys][indexPath.row]: [_serviceItems allValues][indexPath.row]}];
    return cell;
}

#pragma mark - Collection View Delegate Methods
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    NSInteger count = [_serviceItems allKeys].count;
    if (!IS_IPHONE_5_PRIOR)
    {
        if (count > 2)
            return (SCREEN_WIDTH - 60.0f - count * 55.0f)/(count - 1);
    }
    return 10.0f;
}

#pragma mark - SCServiceItemCell Delegate Methods
- (void)itemTapedWithTitle:(NSString *)title ID:(NSString *)ID
{
    NSArray *content = _serviceItems[ID];
    
    __block NSString *string = @"";
    [content enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        string = [string stringByAppendingString:idx ? [NSString stringWithFormat:@"，%@", obj] : obj];
    }];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:string
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

@end
