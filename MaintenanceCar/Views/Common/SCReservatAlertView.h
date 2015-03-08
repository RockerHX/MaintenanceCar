//
//  SCReservatAlertView.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/8.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCServiceItem;

typedef NS_ENUM(NSInteger, SCAlertAnimation) {
    SCAlertAnimationDefault = 0,
    SCAlertAnimationEnlarge,
    SCAlertAnimationMove
};

@protocol SCReservatAlertViewDelegate <NSObject>

@optional
- (void)selectedWithServiceItem:(SCServiceItem *)serviceItem;

@end

@interface SCReservatAlertView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) id      <SCReservatAlertViewDelegate>delegate;

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

- (id)initWithDelegate:(id<SCReservatAlertViewDelegate>)delegate animation:(SCAlertAnimation)anmation;

/**
 *  显示预约项目页面
 */
- (void)show;

@end
