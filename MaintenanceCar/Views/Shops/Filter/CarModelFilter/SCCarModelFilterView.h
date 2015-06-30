//
//  SCCarModelFilterView.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/30.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCCarModelFilterViewDelegate <NSObject>

@required
- (void)selectedCompletedWithParameter:(NSString *)parameter value:(NSString *)value;

@end

@class SCCarModelFilterCategory;
@interface SCCarModelFilterView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSIndexPath *_indexPath;
}

@property (weak, nonatomic) SCCarModelFilterCategory *category;

@property (weak, nonatomic) IBOutlet                 id  <SCCarModelFilterViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet   UICollectionView *collectionView;

- (void)show;
- (void)hidden;

@end
