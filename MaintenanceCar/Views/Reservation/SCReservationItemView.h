//
//  SCReservationItemView.h
//  MaintenanceCar
//
//  Created by Andy on 15/8/26.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCReservationItemView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet   UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@end
