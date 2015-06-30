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
- (void)carModelDidSelectedWithParameter:(NSString *)parameter value:(NSString *)value;

@end

@class SCCarModelFilterCategory;
@interface SCCarModelFilterView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) SCCarModelFilterCategory *category;

@property (weak, nonatomic) IBOutlet                 id  <SCCarModelFilterViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet   UICollectionView *myCarView;
@property (weak, nonatomic) IBOutlet   UICollectionView *otherCarView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myCarViewheightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelHeightConstraint1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelHeightConstraint2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaceConstraint1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaceConstraint2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaceConstraint3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaceConstraint4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaceConstraint5;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaceConstraint6;

- (void)show;
- (void)hidden;
- (void)packUp;

@end
