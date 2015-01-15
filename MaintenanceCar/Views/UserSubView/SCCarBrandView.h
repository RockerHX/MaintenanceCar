//
//  SCCarBrandView.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/11.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCSelectedView.h"

@class SCCarBrand;
@class SCCarBrandView;

@protocol SCCarBrandViewDelegate <NSObject>

@optional
- (void)carBrandViewScrollEnd;
- (void)carBrandViewTitleTaped;
- (void)carBrandViewDidSelectedCar:(SCCarBrand *)car;

@end

@interface SCCarBrandView : SCSelectedView <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView           *titleView;

@property (nonatomic, weak)   id           <SCCarBrandViewDelegate>delegate;
@property (nonatomic, strong) NSArray      *indexTitles;
@property (nonatomic, strong) NSDictionary *carBrands;

- (void)refresh;

@end
