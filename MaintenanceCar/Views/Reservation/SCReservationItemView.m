//
//  SCReservationItemView.m
//  MaintenanceCar
//
//  Created by Andy on 15/8/26.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCReservationItemView.h"

@implementation SCReservationItemView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    SCReservationItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SCReservationItemCell" forIndexPath:indexPath];
//    
//    SCServiceItem *item = [SCAllDictionary share].serviceItems[indexPath.row];
//    cell.textLabel.text = item.service_name;
//    cell.backgroundColor = [item.service_name isEqualToString:@"免费检测"] ? [UIColor colorWithWhite:0.3f alpha:1.0f] : cell.backgroundColor;
//    return cell;
    return nil;
}

@end
