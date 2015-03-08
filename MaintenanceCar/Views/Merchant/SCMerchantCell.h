//
//  SCMerchantCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/30.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCStarView;
@class SCMerchant;

@interface SCMerchantCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView        *merchantIcon;              // 商家图标 - 用于显示商家图标
@property (weak, nonatomic) IBOutlet UILabel            *merchantNameLabel;         // 商家名称栏 - 用于显示商家名称
@property (weak, nonatomic) IBOutlet UILabel            *distanceLabel;             // 商家距离栏 - 用于显示当前位置到商家的直线距离
@property (weak, nonatomic) IBOutlet UICollectionView   *flagView;                  // 商家标签栏 - 用于显示商家标签
@property (weak, nonatomic) IBOutlet SCStarView         *starView;                  // 商家星级 - 用于显示商家评分
@property (weak, nonatomic) IBOutlet UILabel            *specialLabel;              // 商家特点栏 - 用于显示显示商家特点

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flagViewWidthConstraint;   // 商家标签栏宽度

- (void)handelWithMerchant:(SCMerchant *)merchant;

@end