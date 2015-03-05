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

@protocol SCCarBrandViewDelegate <NSObject>

@optional
// SCCarBrandView滚动结束，以便代理对象执行提示等操作
- (void)carBrandViewScrollEnd;
// SCCarBrandView标题栏被点击，以便通知代理对象是否选择关闭此View
- (void)carBrandViewTitleTaped;
// 车辆品牌被选中，通知代理对象经行相关数据操作
- (void)carBrandViewDidSelectedCar:(SCCarBrand *)carBrand;

@end

@interface SCCarBrandView : SCSelectedView <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;                  // 车辆品牌集合View
@property (weak, nonatomic) IBOutlet UILabel          *carBrandLabel;                   // 车辆品牌选择显示栏，用户选择车辆品牌后品牌名称显示在此栏

@property (nonatomic, weak)          id               <SCCarBrandViewDelegate>delegate;
@property (nonatomic, strong)        NSArray          *indexTitles;                     // 索引标题数据集合
@property (nonatomic, strong)        NSDictionary     *carBrands;                       // 汽车品牌数据集合

/**
 *  手动刷新数据
 */
- (void)refresh;

@end
