//
//  SCCarBrandView.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/11.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCSelectedView.h"

@interface SCCarBrandView : SCSelectedView <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSArray      *indexTitles;
@property (nonatomic, strong) NSDictionary *carBrands;

@end
